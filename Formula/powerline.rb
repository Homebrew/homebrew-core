class Powerline < Formula
  desc "statusline plugin for vim, and provides statuslines & prompts"
  homepage "https://github.com/powerline/powerline"
  url "https://github.com/powerline/powerline/archive/2.4.tar.gz"
  sha256 "04050051e033fd1d9b3c60b1183cbe6801185cd5b7495789647ddec72f1bd789"

  bottle do
    cellar :any_skip_relocation
    sha256 "3af142342f5dd1ecea60d93d2e572f505a25bf7fe5777b3798183f010ae7c6b4" => :el_capitan
    sha256 "b115774dc24b1a55d787f91cbc67835c3c145f1085751832737f5b84074e3a49" => :yosemite
    sha256 "4adada4e0f6f6ce5cef17a4594f41ce21f97416893e91b203b6fa7ac099eeabb" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    system "python", *Language::Python.setup_install_args(prefix)
  end

  test do
    system "#{bin}/powerline", "--help"
  end
end
