class Polynote < Formula
  include Language::Python::Shebang

  desc "Polyglot notebook with first-class Scala support"
  homepage "https://polynote.org/"
  url "https://github.com/polynote/polynote/releases/download/0.7.2/polynote-dist.tar.gz"
  sha256 "a43afd3a19343b93ec2d323731f18c296ed0af33b7a56420af2ade40dd14c17b"
  license "Apache-2.0"

  # Upstream marks all releases as "pre-release", so we have to use
  # `GithubReleases` to be able to match pre-release releases until there's a
  # "latest" release for us to be able to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:[.-]\d+)+)$/i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"] # || release["prerelease"]

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "97bcad9e3bec9679599e61a6132a9e2894f545a63467ed6d60654c42ec6dff70"
    sha256 cellar: :any, arm64_sequoia: "f7842ab01a975c0d4f66512aa6fedccaf00f92778bcaeaa4a575a7d1a97193d1"
    sha256 cellar: :any, arm64_sonoma:  "f2fccd1682fed553f175e6edd248b347195ff4630649eb8c802bad07ab6b0194"
    sha256 cellar: :any, sonoma:        "bb24853b7bb693c98096fc7d1b37507b40c72f02c288f432ce0aca99c7016b54"
    sha256               arm64_linux:   "42c1f47c931413bc7f8281ce103b83df555c0b11cd1510f78a765ec62b11f6a6"
    sha256               x86_64_linux:  "f43b22ef1081a4e8be7f6d6e101b20713d85282f53a190c98073a569662543df"
  end

  depends_on "python-setuptools" => :build # to detect numpy (and avoid building numpy when we use jep >= 4.3)
  depends_on "numpy" # used by `jep` for Java primitive arrays
  depends_on "openjdk"
  depends_on "python@3.14"

  resource "jep" do
    url "https://files.pythonhosted.org/packages/52/43/34d397902b3e7c9b667f855e4be41eb8ba5e62df999b563095f713d03cfa/jep-4.2.1.tar.gz"
    sha256 "9ff9f9d431f11dc085220abac9b07905daacc70cfd6096451fea9b142d527c1b"

    # Keep the jep version aligned with upstream's pinned requirement. Can be
    # reconsidered if we hit a compatibility issues with newer Python or numpy.
    livecheck do
      url "https://raw.githubusercontent.com/polynote/polynote/refs/tags/#{LATEST_VERSION}/requirements.txt"
      regex(/^jep==v?(\d+(?:\.\d+)+)$/i)
    end
  end

  def install
    python3 = "python3.14"
    pip_install_prefix = libexec/"vendor"
    java_version = Formula["openjdk"].version.major.to_s
    ENV["JAVA_HOME"] = java_home = Language::Java.java_home(java_version)

    libexec.install Dir["*"]
    rewrite_shebang detected_python_shebang, libexec/"polynote.py"

    resource("jep").stage do
      # Help native shared library in jep resource find libjvm.so on Linux.
      unless OS.mac?
        ENV.append "LDFLAGS", "-L#{java_home}/lib/server"
        ENV.append "LDFLAGS", "-Wl,-rpath,#{java_home}/lib/server"
      end

      system python3, "-m", "pip", "install", *std_pip_args(prefix: pip_install_prefix), "."
    end

    env = Language::Java.overridable_java_home_env(java_version)
    env[:PYTHONPATH] = "#{pip_install_prefix/Language::Python.site_packages(python3)}:${PYTHONPATH}"
    env[:LD_LIBRARY_PATH] = lib.to_s
    (bin/"polynote").write_env_script libexec/"polynote.py", env
  end

  test do
    mkdir testpath/"notebooks"

    assert_path_exists bin/"polynote"
    assert_predicate bin/"polynote", :executable?

    output = shell_output("#{bin}/polynote version 2>&1", 1)
    assert_match "Unknown command version", output

    port = free_port
    (testpath/"config.yml").write <<~YAML
      listen:
        host: 127.0.0.1
        port: #{port}
      storage:
        dir: #{testpath}/notebooks
    YAML

    pid = spawn bin/"polynote", "--config", testpath/"config.yml"
    begin
      sleep 5
      assert_match "<title>Polynote</title>", shell_output("curl -s 127.0.0.1:#{port}")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
