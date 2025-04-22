class Codespell < Formula
  include Language::Python::Virtualenv

  desc "Fix common misspellings in source code and text files"
  homepage "https://github.com/codespell-project/codespell"
  url "https://files.pythonhosted.org/packages/15/e0/709453393c0ea77d007d907dd436b3ee262e28b30995ea1aa36c6ffbccaf/codespell-2.4.1.tar.gz"
  sha256 "299fcdcb09d23e81e35a671bbe746d5ad7e8385972e65dbb833a2eaac33c01e5"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b25d8acdbc85fd54a446dbc8c8b77d008bdb7e19d2fcc034c2bb6bb566cdd80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b25d8acdbc85fd54a446dbc8c8b77d008bdb7e19d2fcc034c2bb6bb566cdd80"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0b25d8acdbc85fd54a446dbc8c8b77d008bdb7e19d2fcc034c2bb6bb566cdd80"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b4c26a1d31143074144646051489279e38203caa49c2f726e90489913ab9b15"
    sha256 cellar: :any_skip_relocation, ventura:       "8b4c26a1d31143074144646051489279e38203caa49c2f726e90489913ab9b15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67af66b8da78c901be3d2be7b8f29f8e082d5bec51194da12ddbeead6eff7f32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b25d8acdbc85fd54a446dbc8c8b77d008bdb7e19d2fcc034c2bb6bb566cdd80"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "1: teh\n\tteh ==> the\n", pipe_output("#{bin}/codespell -", "teh", 65)
  end
end
