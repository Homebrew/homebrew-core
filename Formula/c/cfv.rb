class Cfv < Formula
  include Language::Python::Virtualenv

  desc "Test and create various files (e.g., .sfv, .csv, .crc., .torrent)"
  homepage "https://github.com/cfv-project/cfv"
  url "https://files.pythonhosted.org/packages/29/ca/91cca3d1799d0e74b672e30c41f82a8135fe8d5baf7e6a8af2fdea282449/cfv-3.1.0.tar.gz"
  sha256 "8f352fe4e99837720face2a339ac793f348dd967bacf2a0ff0f5e771340261e3"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ac94febc49f9c57b9bbba4db63d39742f4766e3b769d42255e1b71dc5bc74b21"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2b95b3e71031073ab10c16a1d6b07322562df13bc95d7970c2e27e7bd62f893"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fc8b50c41b14255ffa4629d144166894c3626249fee25bcfeec0890d20091c6"
    sha256 cellar: :any_skip_relocation, sonoma:         "10e0898fa05dce5bf6cf59b04e45bc7018bd2493746205a4012510d0cd9bc883"
    sha256 cellar: :any_skip_relocation, ventura:        "7096f8efcc05d75cff13fd48092a9f173b8191f68ea543c27b9a8e39f8f5b979"
    sha256 cellar: :any_skip_relocation, monterey:       "3efab7c951face9c8489dce5551d1c9c17185a6c0ad502ece1eab707c7b2443a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cf9497ff9cb2d03f2a3bd12460e7708fe0545c534de76f9dcc620ae2e3182b2"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test/test.txt").write "Homebrew!"
    cd "test" do
      system bin/"cfv", "-t", "sha1", "-C", "test.txt"
      assert_predicate Pathname.pwd/"test.sha1", :exist?
      assert_match "9afe8b4d99fb2dd5f6b7b3e548b43a038dc3dc38", File.read("test.sha1")
    end
  end
end
