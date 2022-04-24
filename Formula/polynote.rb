class Polynote < Formula
  include Language::Python::Shebang

  desc "Polyglot notebook with first-class Scala support"
  homepage "https://polynote.org/"
  url "https://github.com/polynote/polynote/releases/download/0.4.5/polynote-dist.tar.gz"
  sha256 "32b02e7e0b42849b660c70f40afe42450eb60807327770c4c7f5a5269ccaebd4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_monterey: "62a4274043626becfc4a03053c1e587c0d544b558e5fea3e456c34f5a7c9ca83"
    sha256 cellar: :any, arm64_big_sur:  "e72f0581a9839ae6cbb0cba192c32e5a9969c18c76447e338181f9f50a083638"
    sha256 cellar: :any, monterey:       "433036a8d84e96224815fdeac331aedeaf17e064a2eb0611e2960535fc2f609d"
    sha256 cellar: :any, big_sur:        "50e6449ee44ad049baaa2015a620e91c759a5d3329cdbd48347233fe3545fc30"
    sha256 cellar: :any, catalina:       "2a9c17df458e4225a381530b01ca8903fa317424604d8156e22877914d00a2de"
    sha256 cellar: :any, mojave:         "1e9021f5c8c3d0071f1775f1c82abf0240060aa2febae948db2ba6993e42f84d"
    sha256               x86_64_linux:   "22377e6c2c3b592c9410c08da93700b5c5afe6458c793769175873f10aecccce"
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
