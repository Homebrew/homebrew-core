class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/37/8b/867cdac69d5212b3eee781e40cfe539c4d9d7b2d4c9290bcdecd2d218176/fonttools-4.27.1.zip"
  sha256 "6e483f77dc5b862452c2888ec944fca5b79cffb741c7469786a442360681b4e8"
  license "MIT"
  revision 1
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1fa2922411634c35a4fed2e0f31665112fc6dfd88f7b65467d5d97b08e5ea755"
    sha256 cellar: :any_skip_relocation, big_sur:       "79d77b7852419c6123b658430398b8597e2faac74043cf58c4b65d624df47b47"
    sha256 cellar: :any_skip_relocation, catalina:      "79d77b7852419c6123b658430398b8597e2faac74043cf58c4b65d624df47b47"
    sha256 cellar: :any_skip_relocation, mojave:        "79d77b7852419c6123b658430398b8597e2faac74043cf58c4b65d624df47b47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "318e514ff22eda960d316d6783ec219e4631422573ed00332b09fe1fb1abeecf"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    on_macos do
      cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
      system bin/"ttx", "ZapfDingbats.ttf"
    end
    on_linux do
      assert_match "usage", shell_output("#{bin}/ttx -h")
    end
  end
end
