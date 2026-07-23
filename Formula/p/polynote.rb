class Polynote < Formula
  include Language::Python::Shebang

  desc "Polyglot notebook with first-class Scala support"
  homepage "https://polynote.org/"
  # TODO: consider switching back to dist when available: https://github.com/polynote/polynote/issues/1486
  url "https://github.com/polynote/polynote/archive/refs/tags/0.7.2.tar.gz"
  sha256 "6802606b38c34b7e0e3717675f6d92cae5419d5927314c51b238bbd15f1d73e4"
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
    sha256 cellar: :any, arm64_tahoe:   "9e426d1ec0e516570fd0c40d836821823e100f7a5a9d80652ec27c4627d335b9"
    sha256 cellar: :any, arm64_sequoia: "01156fa43ee0aa7ded51b47a59e25b6b2aaebdec065a2e6ae63b29aa13247766"
    sha256 cellar: :any, arm64_sonoma:  "0f588261fb28e7388c9d59fe16378620daf5cfe958b7f02bafee2aff444a16b9"
    sha256 cellar: :any, sonoma:        "ef680a88951b4c4c06d5bc61dbbbf4d755840bc82598758010b034389d9e0da8"
    sha256               arm64_linux:   "1dbf3c452f49fa6153801b8800f2d2a5df304785a8a5d7bf7904ccdb42ac703c"
    sha256               x86_64_linux:  "27764487ba7979d2f67f53d6828aef8d2d5a56a9aea1972c0e9c4a5e6b1fe542"
  end

  depends_on "node" => :build
  depends_on "python-setuptools" => :build # to detect numpy (and avoid building numpy when we use jep >= 4.3)
  depends_on "sbt" => :build
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

    # https://github.com/polynote/polynote/blob/master/DEVELOPING.md#building-the-distribution
    cd "polynote-frontend" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "dist"
    end
    system "sbt", "dist"

    libexec.mkpath
    system "tar", "-C", libexec.to_s, "--strip-components", "1", "-xf", "target/polynote-dist.tar.gz"
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
