class Polynote < Formula
  include Language::Python::Shebang

  desc "Polyglot notebook with first-class Scala support"
  homepage "https://polynote.org/"
  url "https://github.com/polynote/polynote/releases/download/0.4.2/polynote-dist.tar.gz"
  sha256 "3d217ef7206d398ecd912959e9e8960d784ab77b2e151a27c08235937a63d802"
  license "Apache-2.0"

  depends_on "numpy" # used by `jep` for Java primitive arrays
  depends_on "openjdk"
  depends_on "python@3.9"

  resource "jep" do
    url "https://files.pythonhosted.org/packages/99/e6/c2e22cfe92762a7add980a40d0d784a0365d53ea656d47610a40d069c086/jep-3.9.1.tar.gz"
    sha256 "7ccd25a92a19a391504e766940190bdcd4d6b3a8488ca4a3adc8eb8cd581c0cb"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"

    with_env(JAVA_HOME: Formula["openjdk"].opt_prefix) do
      resource("jep").stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
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
