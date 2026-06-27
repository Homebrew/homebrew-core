class Cfv < Formula
  include Language::Python::Virtualenv

  desc "Test and create various files (e.g., .sfv, .csv, .crc., .torrent)"
  homepage "https://github.com/cfv-project/cfv"
  url "https://files.pythonhosted.org/packages/90/e2/4982f414f04c47c5344739ecc6dfd70fe75139d0672e0b080929aea309f9/cfv-3.2.0.tar.gz"
  sha256 "090d453fc9beeb9cf37ae8edf7ebae3d9686ac9382d4bea5df9191b429e6403c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ab4f236a2f53235d5d8acc132cf81c3c5c44c663e019d0107710aa2d5766b7fc"
  end

  depends_on "python@3.14"

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
