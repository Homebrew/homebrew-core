class Convert2pdf < Formula
  desc "Command-line tool to convert between Office formats and PDF"
  homepage "https://github.com/shar-mayank/convert2pdf"
  url "https://github.com/shar-mayank/convert2pdf/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "e55770b0c4969e9bc09e5934e87b42452bdb5f53dba39dc7c0d1cb1c3629dda2"
  license "MIT"
  version "1.0.0"
  head "https://github.com/shar-mayank/convert2pdf.git", branch: "main"

  depends_on "python@3.13"

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/b9/14/78635daab4b07c0a9a5cd3e9b488b6772e5c02c5c3a766c125ebd77b8c35/numpy-1.26.4.tar.gz"
    sha256 "2a02aba9ed12e4ac4eb3ea9421c420301a0c6460d9830d74a9df87efa4912010"
  end

  resource "pdf2docx" do
    url "https://files.pythonhosted.org/packages/f4/ba/be939a4a52fb8715a8b141c0a51ee82aecf1988b8f3d3688c54cbc90af71/pdf2docx-0.5.8.tar.gz"
    sha256 "892eca8f7c418025af549e9bc92ce18168c5e0ee97343ef8dedf465bdd1dee08"
  end

  resource "pypdf2" do
    url "https://files.pythonhosted.org/packages/cd/b5/4dc32c349b534f9bde506c5c119bd201c3e558a57cc6901a82df7750a865/PyPDF2-3.0.1.tar.gz"
    sha256 "a74408f69ba6271f71b9352ef4ed03dc53a31aa404d29b5d31f53bfecb1a3f6a"
  end

  resource "python-pptx" do
    url "https://files.pythonhosted.org/packages/16/51/4bb8b4f50e452228c7764f7bc970a14e3aab96e96d2dcf6ea9041de51871/python_pptx-1.0.2.tar.gz"
    sha256 "479a8af0eaf0f0d76b6f00b0b6e5e59518e7d88a6291b8a068e86e9e4633a6e6"
  end

  def install
    # Install the main script
    bin.install "convert2pdf"

    # Install shell completions
    bash_completion.install "completions/convert2pdf.bash" => "convert2pdf"
    zsh_completion.install "completions/convert2pdf.zsh" => "_convert2pdf"

    # Install requirements.txt for --setup command
    pkgshare.install "requirements.txt"
  end

  def caveats
    <<~EOS
      convert2pdf requires additional setup:

      1. Install LibreOffice for Office-to-PDF conversions:
           brew install --cask libreoffice

      2. Install Python dependencies:
           convert2pdf --setup
         Or manually:
           pip3 install pdf2docx PyPDF2 python-pptx "numpy<2.0"
    EOS
  end

  test do
    # Version test
    assert_match "convert2pdf version #{version}", shell_output("#{bin}/convert2pdf --version")

    # Help test
    assert_match "Usage:", shell_output("#{bin}/convert2pdf --help")

    # Test that the script is executable
    assert_predicate bin/"convert2pdf", :executable?
  end
end