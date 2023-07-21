class Gptask < Formula
  include Language::Python::Virtualenv

  desc "My Awesome Python Package"
  homepage "https://github.com/chitalian/gptask"
  url "https://files.pythonhosted.org/packages/bf/5d/420c886c35881ff024685cca96510966c474150283f06c2e60e317dd689f/gptask_cli-0.1.1.tar.gz"
  sha256 "7707410e63b828d76c17e10f03e990d4626a35eacbdb95c427b8d960d7b5ad6f"
  license "MIT"

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/gptask", "--help"
  end
end
