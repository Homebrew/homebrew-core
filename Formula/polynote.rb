class Polynote < Formula
  include Language::Python::Shebang

  desc "Polyglot notebook with first-class Scala support"
  homepage "https://polynote.org/"
  url "https://github.com/polynote/polynote/releases/download/0.5.0/polynote-dist.tar.gz"
  sha256 "173feb74da99c87e7b658b6f5a6400b0ee8a7da9a5975cde196a3285f471e152"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "0af542d492d91b4215463fa08cacbe3ed2e042b214ace807f73d49ec0ec83053"
    sha256 cellar: :any, arm64_monterey: "25288879b2bb601cf95384ae5ae01bd3b7734f28ea06f3627afed1c116f85f99"
    sha256 cellar: :any, arm64_big_sur:  "88c81ed22651a67114ddc8af9ec4307e45f31ac642d296896ded5295793ed424"
    sha256 cellar: :any, ventura:        "d2bc6efa2010a4be9dfcf0265ceb016e69863ae8ca91eb1ff483d1ea7d532feb"
    sha256 cellar: :any, monterey:       "ccf759d29c2dc1cb8365f26ad24595b9413af5df63b02b5b1370562a2dc7371a"
    sha256 cellar: :any, big_sur:        "e9682de198d26ec46ec3529f481bff0fbab6fb14821591206b21fadccc9641cb"
    sha256               x86_64_linux:   "80431ae7bf4b8ea682af60831efa18dcec859388734899b198b8773bb4919230"
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
