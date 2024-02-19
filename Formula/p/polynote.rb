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
    rebuild 1
    sha256 cellar: :any, arm64_sonoma:   "9590805d7fd26247263cced0d0306bb7c863b95ef4354b27bae92c135efc1552"
    sha256 cellar: :any, arm64_ventura:  "a93aa1f2b84d6e1137fea692702eae407d1ff09ad3318c6c5db0a4d97b24ce75"
    sha256 cellar: :any, arm64_monterey: "7e5f4992e898ae22d50966b4855fa672fa7a15a2c3ad41d34ea94d6bfa7b14bb"
    sha256 cellar: :any, sonoma:         "a50ff8929239623319fa68c68ba80e31b7212a6350485b74eb6b7c45da0c6fc4"
    sha256 cellar: :any, ventura:        "e272c680279935779e96fd7f63fe5ce41b7702975e62d732846eb094f5103b87"
    sha256 cellar: :any, monterey:       "92e35fd7f1bec7d1cabee9e55d15aedf037fe0c94d9511dca040e1f2e9c49f09"
    sha256               x86_64_linux:   "f9ec11fd988d61e408555488aa45f20ae99d998c80db09ec0ca2a009a10e9cf5"
  end

  depends_on "python-setuptools" => :build
  depends_on "numpy" # used by `jep` for Java primitive arrays
  depends_on "openjdk"
  depends_on "python@3.12"

  resource "jep" do
    url "https://files.pythonhosted.org/packages/b3/0c/d208bc8a86f032b9a9270876129aadb41fa1a4baa172d68a29c579950856/jep-4.1.1.tar.gz"
    sha256 "5914a4d815a7e86819f55be3de840edc2d3fe0d0b3f67626e5cea73841b1d1c0"
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

        system python3, "-m", "pip", "install", *std_pip_args(prefix: libexec/"vendor"), "."
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
