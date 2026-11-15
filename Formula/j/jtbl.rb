class Jtbl < Formula
  include Language::Python::Virtualenv

  desc "Convert JSON and JSON Lines to terminal, CSV, HTTP, and markdown tables"
  homepage "https://github.com/kellyjonbrazil/jtbl"
  url "https://files.pythonhosted.org/packages/9e/7c/b21f3383ca611b56dbc281081cca73a24274c3f39654e7fe196d73a67af6/jtbl-1.6.0.tar.gz"
  sha256 "7de0cb08ebb2b3a0658229a8edd4204c6944cbd9e3e04724a9ea235a61c115a5"
  license "MIT"
  head "https://github.com/kellyjonbrazil/jtbl.git", branch: "master"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, all: "e7ece66dbc2f33abd65e261d5811bd20cd1277c520cef65b072ce05eae0fe6d7"
  end

  depends_on "python@3.15"

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  def install
    venv = virtualenv_install_with_resources
    man1.install "man/jtbl.1"

    # Build an `:all` bottle
    inreplace venv.site_packages/"jtbl-#{version}.dist-info/METADATA", "/usr/local/Cellar", "#{HOMEBREW_PREFIX}/Cellar"
  end

  test do
    assert_match <<~EOS, pipe_output(bin/"jtbl", "[{\"a\":1,\"b\":1},{\"a\":2,\"b\":2}]")
        a    b
      ---  ---
        1    1
        2    2
    EOS

    assert_match version.to_s, shell_output("#{bin}/jtbl --version 2>&1", 1)
  end
end
