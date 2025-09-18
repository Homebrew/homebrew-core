class Cfv < Formula
  include Language::Python::Virtualenv

  desc "Test and create various files (e.g., .sfv, .csv, .crc., .torrent)"
  homepage "https://github.com/cfv-project/cfv"
  url "https://files.pythonhosted.org/packages/29/ca/91cca3d1799d0e74b672e30c41f82a8135fe8d5baf7e6a8af2fdea282449/cfv-3.1.0.tar.gz"
  sha256 "8f352fe4e99837720face2a339ac793f348dd967bacf2a0ff0f5e771340261e3"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "fb2e9074946326a9618313d03fa78b596e0e65f68b11c3f83de2215a260731c0"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test/test.txt").write "Homebrew!"

    cd "test" do
      assert_match version.to_s, shell_output("#{bin}/cfv --version")

      system bin/"cfv", "-t", "sha1", "-C", "test.txt"
      assert_path_exists Pathname.pwd/"test.sha1"
      assert_match "9afe8b4d99fb2dd5f6b7b3e548b43a038dc3dc38", File.read("test.sha1")
    end
  end
end
