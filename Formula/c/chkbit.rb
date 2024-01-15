class Chkbit < Formula
  include Language::Python::Virtualenv

  desc "Check the data integrity of your files across backups!"
  homepage "https://github.com/laktak/chkbit-py"
  url "https://github.com/laktak/chkbit-py/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "4de1e7e1207b8fb40ab3d8c01ff7ac8fcbb239dbc9a1688b067ca536ce865d62"
  license "MIT"
  head "https://github.com/laktak/chkbit-py.git", branch: "master"

  depends_on "pyinstaller" => :build
  depends_on "rust" => :build
  depends_on "python@3.12"

  uses_from_macos "zlib"

  resource "blake3" do
    url "https://files.pythonhosted.org/packages/26/ed/c15b8f1878f62a037f398f8f2e6405c8b6d8deeffb457aee981c88bc2630/blake3-0.3.4.tar.gz"
    sha256 "4b7ef354144a2a19d7dbbfebce11735f68154e5190f9cc53825237bdb1bb78af"
  end

  def python3
    "python3.12"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match(/usage: chkbit \[-h\].*/, shell_output("#{bin}/chkbit"))

    # test operation
    mkdir testpath/"foo" do
      (testpath/"foo/one.txt").write <<~EOS
        testing
        testing
        testing
      EOS
      system bin/"chkbit", "-u", testpath/"foo/"
      assert_predicate testpath/"foo/.chkbit", :exist?
    end
  end
end
