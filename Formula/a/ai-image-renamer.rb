# file: ai-image-renamer.rb
class AiImageRenamer < Formula
  include Language::Python::Virtualenv

  desc "Rename images based on AI-generated descriptions"
  homepage "https://docs.kolja-nolte.com/ai-image-renamer-cli"
  # Fixed: Moved URL before License and switched to PyPI source as requested
  url "https://files.pythonhosted.org/packages/source/a/ai_image_renamer/ai_image_renamer-1.2.0.tar.gz"
  sha256 "25d555240780ce5b6822b4c8a5ef5a884d37362de2a4a7acbf2666d39aa26c56"
  license "BSD-2-Clause" # Fixed: Matched GitHub license found by audit

  depends_on "python@3.12"

  # Fixed: Use PyPI source URL format
  resource "filetype" do
    url "https://files.pythonhosted.org/packages/source/f/filetype/filetype-1.2.0.tar.gz"
    sha256 "66ef9663989e24823cf5a60a95447b97c0f1e00305b0f49c00b0d39373970b80"
  end

  # Fixed: Use PyPI source URL format
  resource "groq" do
    url "https://files.pythonhosted.org/packages/source/g/groq/groq-0.18.0.tar.gz"
    sha256 "8e2ccfea406d68b3525af4b7c0e321fcb3d2a73fc60bb70b4156e6cd88c72f03"
  end

  # Fixed: Resource name changed to 'python-dotenv' -> 'python_dotenv' (or 'python')
  # audit suggested 'python' but usually 'python-dotenv' or 'python_dotenv' is required for the PyPI match.
  # Let's use the exact PyPI package slug 'python-dotenv' and ensure URL is 'source' format.
  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/source/p/python-dotenv/python-dotenv-1.0.1.tar.gz"
    sha256 "e324ee90a023d808f1959c46bcbc04446a10ced277783dc6ee09987c37ec10ca"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "usage", shell_output("#{bin}/rename-images --help")
  end
end
