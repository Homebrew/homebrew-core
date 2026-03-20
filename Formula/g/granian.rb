class Granian < Formula
  include Language::Python::Virtualenv

  desc "Rust HTTP server for Python ASGI/RSGI/WSGI applications"
  homepage "https://github.com/emmett-framework/granian"
  url "https://files.pythonhosted.org/packages/57/19/d4ea523715ba8dd2ed295932cc3dda6bb197060f78aada6e886ff08587b2/granian-2.7.2.tar.gz"
  sha256 "cdae2f3a26fa998d41fefad58f1d1c84a0b035a6cc9377addd81b51ba82f927f"
  license "BSD-3-Clause"

  depends_on "maturin" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "python@3.14" => [:build, :test]
  depends_on "rust" => :build

  on_linux do
    depends_on "patchelf" => :build
  end

  pypi_packages extra_packages: ["uvloop"]

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "uvloop" do
    url "https://files.pythonhosted.org/packages/06/f0/18d39dbd1971d6d62c4629cc7fa67f74821b0dc1f5a77af43719de7936a7/uvloop-0.22.1.tar.gz"
    sha256 "6c84bae345b9147082b17371e3dd5d42775bddce91f885499017f4607fdaf39f"
  end

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.start_with?("python@") }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python3|
      resources.each do |r|
        r.stage do
          system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
        end
      end
      system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    end
  end

  test do
    (testpath/"app.py").write <<~PYTHON
      async def app(scope, receive, send):
          assert scope["type"] == "http"
          await send({"type": "http.response.start", "status": 200, "headers": []})
          await send({"type": "http.response.body", "body": b"ok"})
    PYTHON

    pythons.each do |python3|
      port = free_port
      log = testpath/"granian-#{python3.basename}.log"
      pid = spawn python3, "-m", "granian",
                  "--interface", "asgi",
                  "--loop", "asyncio",
                  "--host", "127.0.0.1",
                  "--port", port.to_s,
                  "app:app",
                  out: log.to_s, err: log.to_s

      tries = 0
      until log.exist? && log.read.include?("Started worker")
        sleep 1
        tries += 1
        raise "granian did not start within 30s" if tries >= 30
      end
      assert_match "ok", shell_output("curl -s http://127.0.0.1:#{port}/")
    ensure
      Process.kill("TERM", pid) if pid
      Process.wait(pid) if pid
    end
  end
end
