class Opendoor < Formula
  include Language::Python::Virtualenv

  desc "CLI for web reconnaissance, directory discovery, and exposure assessment"
  homepage "https://github.com/stanislav-web/OpenDoor"
  url "https://files.pythonhosted.org/packages/df/98/d3ab61a1685f663c6aae6658a75e2a8ebab81732d38e4e1a5db1e2172865/opendoor-5.17.0.tar.gz"
  sha256 "df69d87da68ee8dcd5c9bea01fdfac358f05b82f2fe6d4234d6107336d78510c"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c5b562c262c27a2bb4a79249412f0a45f65f97dd0215453277c281d77cb93d8e"
  end

  depends_on "python@3.14"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  def install
    venv = virtualenv_install_with_resources

    # Build :all bottle
    %w[base openvpn wireguard].each do |f|
      file = venv.site_packages/"src/core/network/adapters/#{f}.py"
      inreplace file, "/usr/local", HOMEBREW_PREFIX
      inreplace file, "/opt/homebrew", HOMEBREW_PREFIX
    end
    inreplace venv.site_packages/"src/core/core.py", "/usr/local", HOMEBREW_PREFIX
    inreplace venv.site_packages.glob("opendoor-*.dist-info/METADATA"), "/opt/homebrew", HOMEBREW_PREFIX
    inreplace libexec/"opendoor.conf", "/opt/homebrew", HOMEBREW_PREFIX
  end

  test do
    python3 = "python3.14"
    port = free_port
    wordlist = testpath/"wordlist.txt"

    wordlist.write ["opendoor-health.txt", "missing-opendoor.txt", ""].join(10.chr)
    (testpath/"opendoor-health.txt").write "ok"

    server_pid = spawn python3, "-m", "http.server", port.to_s, "--bind", "localhost", "--directory", testpath.to_s

    sleep 5

    output = shell_output(
      "#{bin}/opendoor --host localhost --port #{port} --scheme http:// " \
      "--scan directories --method GET --wordlist #{wordlist} " \
      "--threads 1 --include-status 200 --debug -1 2>&1",
    )

    assert_match "opendoor-health.txt", output
    refute_match "missing-opendoor.txt", output
  ensure
    Process.kill("TERM", server_pid)
    Process.wait(server_pid)
  end
end
