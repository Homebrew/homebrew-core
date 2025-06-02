class Cfv < Formula
  include Language::Python::Virtualenv

  desc "Test and create various files (e.g., .sfv, .csv, .crc., .torrent)"
  homepage "https://github.com/cfv-project/cfv"
  url "https://files.pythonhosted.org/packages/29/ca/91cca3d1799d0e74b672e30c41f82a8135fe8d5baf7e6a8af2fdea282449/cfv-3.1.0.tar.gz"
  sha256 "8f352fe4e99837720face2a339ac793f348dd967bacf2a0ff0f5e771340261e3"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4364889501244abb0dec42000034cbb135f74ed15f6bdd7ac2ad21e580297997"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4364889501244abb0dec42000034cbb135f74ed15f6bdd7ac2ad21e580297997"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4364889501244abb0dec42000034cbb135f74ed15f6bdd7ac2ad21e580297997"
    sha256 cellar: :any_skip_relocation, sonoma:        "b166757b27f5ba3c246536507dee3c460909e17a5329a897c9280ee81f424d66"
    sha256 cellar: :any_skip_relocation, ventura:       "b166757b27f5ba3c246536507dee3c460909e17a5329a897c9280ee81f424d66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67503e1767bc34de8448c8dc3468a483a7e6a1f9bff13768b08ff3cdc46c86b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4364889501244abb0dec42000034cbb135f74ed15f6bdd7ac2ad21e580297997"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test/test.txt").write "Homebrew!"

    cd "test" do
      system bin/"cfv", "-t", "sha1", "-C", "test.txt"
      assert_path_exists Pathname.pwd/"test.sha1"
      assert_match "9afe8b4d99fb2dd5f6b7b3e548b43a038dc3dc38", File.read("test.sha1")
    end
  end
end
