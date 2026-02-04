class Convert2pdf < Formula
  desc "Command-line tool to convert between Office formats and PDF"
  homepage "https://github.com/shar-mayank/convert2pdf"
  url "https://github.com/shar-mayank/convert2pdf/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "143b7abe1592ffc21a13f66c75d6df5f201b3df9f48b962e4d3643d71b64bbad"
  license "MIT"
  head "https://github.com/shar-mayank/convert2pdf.git", branch: "main"

  depends_on :macos

  def install
    bin.install "convert2pdf"
    bash_completion.install "completions/convert2pdf.bash" => "convert2pdf"
    zsh_completion.install "completions/convert2pdf.zsh" => "_convert2pdf"
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
    # Verify the binary is installed and executable
    assert_predicate bin/"convert2pdf", :executable?

    # Test version output
    assert_match "convert2pdf version", shell_output("#{bin}/convert2pdf --version")

    # Test help output contains expected sections
    help_output = shell_output("#{bin}/convert2pdf --help")
    assert_match "Usage:", help_output
    assert_match "Supported input formats:", help_output
    assert_match "--batch", help_output

    # Test error handling: no arguments shows usage
    output = shell_output("#{bin}/convert2pdf 2>&1", 1)
    assert_match "No input file specified", output

    # Test error handling: non-existent file
    output = shell_output("#{bin}/convert2pdf nonexistent.docx 2>&1", 1)
    assert_match "not found", output

    # Test error handling: unsupported file format
    (testpath/"test.unsupported").write("test content")
    output = shell_output("#{bin}/convert2pdf #{testpath}/test.unsupported 2>&1", 1)
    assert_match "Unsupported file format", output
  end
end
