class Polynote < Formula
  include Language::Python::Shebang

  desc "Polyglot notebook with first-class Scala support"
  homepage "https://polynote.org/"
  url "https://github.com/polynote/polynote/releases/download/0.6.0/polynote-dist.tar.gz"
  sha256 "ec4e0e434f5996e83fd9490dbd6b99cbb724a39fa4074d3198eb16662ddf1d4a"
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
    sha256 cellar: :any, arm64_sonoma:   "e5ca852520d67545e8024fc00c164068768be2f80ff1362b96ba45e25d97d118"
    sha256 cellar: :any, arm64_ventura:  "adef7a68ddeabd34a5dfb6dbe09281a3432a7d1262a73638ba7b7936a82ed332"
    sha256 cellar: :any, arm64_monterey: "7f79ab9b7f726fd425b3fbe3c78fe412c31b0bcd8530ebd8cb005c00689707eb"
    sha256 cellar: :any, sonoma:         "8b312ff6e53371243da3729db6383eaf824d3526fb6219f4c8550d1cf25e18e6"
    sha256 cellar: :any, ventura:        "03e05340bd23eabb467df101ce9dbc4e0f89a4cc008b437578bb00a4975d9d2b"
    sha256 cellar: :any, monterey:       "0d3412b343ea542425c770ccb27d129dfb4b79ce17f79b194ab8dedfc796073b"
    sha256               x86_64_linux:   "5330ce06a98879026081054dc919bf2ff118d427eeac4c79422bf5652346b03e"
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
    env["LD_LIBRARY_PATH"] = lib
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
