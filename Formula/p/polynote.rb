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
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "56198e1f17cb8971b8a0ebc92aeb1631aafc6973a26f9fb6958e32e154c195c6"
    sha256 cellar: :any, arm64_tahoe:       "c4fb116bffc7612087967855144b11af3e742a5524b0a61ee63798360272a706"
    sha256 cellar: :any, arm64_sequoia:     "9ae73b23ad747fc483de5d6ad3dc1987b255c6bef3295011935fd37d8c8dd317"
    sha256               arm64_linux:       "eb1c4df7d177825d5046fe930f8f75c3b209255a751a8a15c99adb929052280b"
    sha256               x86_64_linux:      "44430e31a4946a97f14a00993b3aabd03d53621929131a6a47edfa5b128278e1"
  end

  depends_on "python-setuptools" => :build # to detect numpy (and avoid building numpy when we use jep >= 4.3)
  depends_on "numpy" # used by `jep` for Java primitive arrays
  depends_on "openjdk"
  depends_on "python@3.15"

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
