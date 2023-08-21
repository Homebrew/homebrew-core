class Polynote < Formula
  include Language::Python::Shebang

  desc "Polyglot notebook with first-class Scala support"
  homepage "https://polynote.org/"
  url "https://github.com/polynote/polynote/releases/download/0.5.2/polynote-dist.tar.gz"
  sha256 "5dd26119e1b472fad0e0f24a43bb621a6f585f143440dbdeaf35e53d8b5bd046"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "811cc8d34cae7dd7d978ba2f58e4feb7b9ed5c1aa1a3850da88ce2d5190e90dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0edb80020862e5a35d3a61f9fe2d1b73e7a36b1f4fff3847970e5d76e0d8074d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53131cfe180688890e81eb1e8124bc00dde06537ad05925229735407d9aef193"
    sha256 cellar: :any_skip_relocation, ventura:        "73585da59526fb84d37a5604e1a5346bcf7e891a3a6bf5460f4b2ebeb928395b"
    sha256 cellar: :any_skip_relocation, monterey:       "fe02e612290eebc6ebc844ea9cb4261d8e932bad97993ae8ce6c7c6c9c8882e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "184118891cf00b1b00a3e5242d31ed6bb0c617bfa0d53765372ffe1fd0da8544"
    sha256                               x86_64_linux:   "0dcf1e96d83ab62405b09c48f796b9ffe3d729cbc6ad1701c552079d93753f3a"
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
