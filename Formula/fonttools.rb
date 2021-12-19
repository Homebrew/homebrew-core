class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://files.pythonhosted.org/packages/ce/1b/d4cd86f4e6cbd54a3c4f807015b116299bcd6d6587ea0645d88ba9d932bb/fonttools-4.28.5.zip"
  sha256 "545c05d0f7903a863c2020e07b8f0a57517f2c40d940bded77076397872d14ca"
  license "MIT"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59a583ee05230a61a0284f0f750a8cfd8452b967e3a775e6544a749dc905f4f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59a583ee05230a61a0284f0f750a8cfd8452b967e3a775e6544a749dc905f4f6"
    sha256 cellar: :any_skip_relocation, monterey:       "380e284e18467bbccde91aef1b41550718677e4d5ba050fbc9d5e7bf763d54d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "380e284e18467bbccde91aef1b41550718677e4d5ba050fbc9d5e7bf763d54d6"
    sha256 cellar: :any_skip_relocation, catalina:       "380e284e18467bbccde91aef1b41550718677e4d5ba050fbc9d5e7bf763d54d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf4f103de241bea2f1045b86b12304d7cae8a01e0cb51aa3e557239214910880"
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
