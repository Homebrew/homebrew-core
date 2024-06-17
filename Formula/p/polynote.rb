class Polynote < Formula
  include Language::Python::Shebang

  desc "Polyglot notebook with first-class Scala support"
  homepage "https://polynote.org/"
  url "https://github.com/polynote/polynote/releases/download/0.5.1/polynote-dist.tar.gz"
  sha256 "e7715dd7e044cdf4149a1178b42a506c639a31bcb9bf97d08cec4d1fe529bf18"
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
    sha256 cellar: :any, arm64_sonoma:   "8177302c01e8c767c7535352acfed7550b02589168c901a91d7e30dba8d83d44"
    sha256 cellar: :any, arm64_ventura:  "a4ca4925de7aded7490e10b189a1704e0088df923d9397e298ff43bbaf31fd5e"
    sha256 cellar: :any, arm64_monterey: "c770429f67aa53551cb9e6b2a44af16d8e0fb60487f84ebed24749d0d855f4d1"
    sha256 cellar: :any, sonoma:         "93922c92ebf8c9f6f93681f65b9390936a21cf202e40e6551db4bcbe7956b31d"
    sha256 cellar: :any, ventura:        "67ff220afe410cc3a1eab89a0dce2687573ef735500d31a178a1bad64e3a385a"
    sha256 cellar: :any, monterey:       "624a6c403fc577fc760e72e7b29f4ad52430509dbfdfdbda80cef914312c1a42"
    sha256               x86_64_linux:   "aa388f3e97800bdf1dd6f861ab96ebb3631792d4edf63e002d07d0e3e0c76182"
  end

  depends_on "numpy" # used by `jep` for Java primitive arrays
  depends_on "openjdk"
  depends_on "python@3.12"

  resource "jep" do
    url "https://files.pythonhosted.org/packages/16/94/3bc40b4683442bd34e7c511cbe5c1a1bb8d5d6de1f4955991a07fe02c836/jep-4.2.0.tar.gz"
    sha256 "636368786b4f3dc29510454e0580a432e45e696de99ce973a3caef6faec35287"
  end

  def install
    python3 = "python3.12"

    with_env(JAVA_HOME: Language::Java.java_home) do
      resource("jep").stage do
        # Help native shared library in jep resource find libjvm.so on Linux.
        unless OS.mac?
          ENV.append "LDFLAGS", "-L#{Formula["openjdk"].libexec}/lib/server"
          ENV.append "LDFLAGS", "-Wl,-rpath,#{Formula["openjdk"].libexec}/lib/server"
        end

        system python3, "-m", "pip", "install", *std_pip_args(prefix: libexec/"vendor", build_isolation: true), "."
      end
    end

    libexec.install Dir["*"]
    rewrite_shebang detected_python_shebang, libexec/"polynote.py"

    env = Language::Java.overridable_java_home_env
    env["PYTHONPATH"] = libexec/"vendor"/Language::Python.site_packages(python3)
    (bin/"polynote").write_env_script libexec/"polynote.py", env
  end

  test do
    mkdir testpath/"notebooks"

    assert_predicate bin/"polynote", :exist?
    assert_predicate bin/"polynote", :executable?

    output = shell_output("#{bin}/polynote version 2>&1", 1)
    assert_match "Unknown command version", output

    port = free_port
    (testpath/"config.yml").write <<~EOS
      listen:
        host: 127.0.0.1
        port: #{port}
      storage:
        dir: #{testpath}/notebooks
    EOS

    begin
      pid = fork do
        exec bin/"polynote", "--config", "#{testpath}/config.yml"
      end
      sleep 5

      assert_match "<title>Polynote</title>", shell_output("curl -s 127.0.0.1:#{port}")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
