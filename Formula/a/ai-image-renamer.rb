class AiImageRenamer < Formula
  include Language::Python::Virtualenv

  desc "Rename images based on AI-generated descriptions using Groq API"
  homepage "https://docs.kolja-nolte.com/ai-image-renamer-cli"
  license "MIT"
  url "https://files.pythonhosted.org/packages/source/a/ai-image-renamer/ai_image_renamer-1.2.0.tar.gz"
  sha256 "25d555240780ce5b6822b4c8a5ef5a884d37362de2a4a7acbf2666d39aa26c56"
  head "https://github.com/thaikolja/homebrew-core.git", branch: "main"

  depends_on "python@3.13"

  resource "groq" do
    url "https://files.pythonhosted.org/packages/source/g/groq/groq-1.1.2.tar.gz"
    sha256 "9ec2b5b6a1c4856a8c6c38741353c5ab37472a4e3fded02af783750d849cc988"
  end

  resource "filetype" do
    url "https://files.pythonhosted.org/packages/source/f/filetype/filetype-1.2.0.tar.gz"
    sha256 "66b56cd6474bf41d8c54660347d37afcc3f7d1970648de365c102ef77548aadb"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/source/p/python-dotenv/python_dotenv-1.2.2.tar.gz"
    sha256 "2c371a91fbd7ba082c2c1dc1f8bf89ca22564a087c2c287cd9b662adde799cf3"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"rename-images", "--version"
    system bin/"rename-images", "--help"
  end
end
