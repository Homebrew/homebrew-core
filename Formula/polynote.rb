class Polynote < Formula
  include Language::Python::Shebang

  desc "Polyglot notebook with first-class Scala support"
  homepage "https://polynote.org/"
  url "https://github.com/polynote/polynote/releases/download/0.4.5/polynote-dist.tar.gz"
  sha256 "32b02e7e0b42849b660c70f40afe42450eb60807327770c4c7f5a5269ccaebd4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_monterey: "ae1360c0e00a9a4b3da148053ea6faa578b41b6c4ef524771d110d7e67d44498"
    sha256 cellar: :any, arm64_big_sur:  "7e964925acabf6c3a6ce355cd6481d96daf4861e73cda963da5dc70326389548"
    sha256 cellar: :any, monterey:       "58b34b1b44f326c8aa1fc357ef4124e1064da05566f5c3a37e98fa325e43eae5"
    sha256 cellar: :any, big_sur:        "5990e8cf346855098c4b6af3761ba77b74b7edaa422f58f35bd5b676984ea36e"
    sha256 cellar: :any, catalina:       "7a3d9d4084596c2de11b6ed19369789bde963fdcfacc8b9ec87b2aeedff95d55"
    sha256               x86_64_linux:   "c9b2307cbf6a17302c4c19c96d7f8ed51934cc1a0df49c115b757837d6ee4714"
  end

  depends_on "numpy" # used by `jep` for Java primitive arrays
  depends_on "openjdk"
  depends_on "python@3.10"

  resource "jep" do
    url "https://files.pythonhosted.org/packages/19/6e/745f9805f5cec38e03e7fed70b8c66d4c4ec3997cd7de824d54df1dfb597/jep-4.0.0.tar.gz"
    sha256 "fb27b1e95c58d1080dabbbc9eba9e99e69e4295f67df017b70df20f340c150bb"
  end

  def install
    site_packages = libexec/"vendor"/Language::Python.site_packages("python3")
    ENV.prepend_create_path "PYTHONPATH", site_packages

    with_env(JAVA_HOME: Language::Java.java_home) do
      resource("jep").stage do
        # Help native shared library in jep resource find libjvm.so on Linux.
        unless OS.mac?
          ENV.append "LDFLAGS", "-L#{Formula["openjdk"].libexec}/lib/server"
          ENV.append "LDFLAGS", "-Wl,-rpath,#{Formula["openjdk"].libexec}/lib/server"
        end

        system "python3", *Language::Python.setup_install_args(libexec/"vendor"),
                          "--install-lib=#{site_packages}"
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
