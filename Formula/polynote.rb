class Polynote < Formula
  include Language::Python::Shebang

  desc "Polyglot notebook with first-class Scala support"
  homepage "https://polynote.org/"
  url "https://github.com/polynote/polynote/releases/download/0.5.1/polynote-dist.tar.gz"
  sha256 "e7715dd7e044cdf4149a1178b42a506c639a31bcb9bf97d08cec4d1fe529bf18"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "17484d27531470d57c182ea117f90f905e6f337892d77bd540aae7ff835acd44"
    sha256 cellar: :any, arm64_monterey: "2ae123b944f380cbaac774768c300ba24ed641e9577b3b3a440962bcfcab4806"
    sha256 cellar: :any, arm64_big_sur:  "d977082f5ced92ddf993fa0646c334143cc7a0366342b13e0f7955d969716fee"
    sha256 cellar: :any, ventura:        "2850dbf9d6ef7358f20a23f4d8fc50d630cfbd798764119a57c91d6f2ab9a619"
    sha256 cellar: :any, monterey:       "d8afbfd0f181b1b427fd6826949b5c84a16d0ac8c2481894d328b5a2fd4c857b"
    sha256 cellar: :any, big_sur:        "fa4305ad30d2da3d531e0965357dbf78053a3710f8d6ceeddaa7d7fc277ecf0c"
    sha256               x86_64_linux:   "4727c9959271464c8193c106a68aa1748e9af1044686553e63993b7960970281"
  end

  depends_on "numpy" # used by `jep` for Java primitive arrays
  depends_on "openjdk"
  depends_on "python@3.11"

  resource "jep" do
    url "https://files.pythonhosted.org/packages/b3/0c/d208bc8a86f032b9a9270876129aadb41fa1a4baa172d68a29c579950856/jep-4.1.1.tar.gz"
    sha256 "5914a4d815a7e86819f55be3de840edc2d3fe0d0b3f67626e5cea73841b1d1c0"
  end

  def install
    python3 = "python3.11"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor"/Language::Python.site_packages(python3)

    with_env(JAVA_HOME: Language::Java.java_home) do
      resource("jep").stage do
        # Help native shared library in jep resource find libjvm.so on Linux.
        unless OS.mac?
          ENV.append "LDFLAGS", "-L#{Formula["openjdk"].libexec}/lib/server"
          ENV.append "LDFLAGS", "-Wl,-rpath,#{Formula["openjdk"].libexec}/lib/server"
        end

        system python3, *Language::Python.setup_install_args(libexec/"vendor", python3)
      end
    end

    libexec.install Dir["*"]
    rewrite_shebang detected_python_shebang, libexec/"polynote.py"

    env = Language::Java.overridable_java_home_env
    env["PYTHONPATH"] = ENV["PYTHONPATH"]
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
