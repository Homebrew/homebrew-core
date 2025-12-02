class Cdargs < Formula
  desc "Directory bookmarking system - Enhanced cd utilities"
  homepage "https://github.com/cbxbiker61/cdargs"
  url "https://github.com/cbxbiker61/cdargs/archive/refs/tags/2.1.tar.gz"
  sha256 "062515c3fbd28c68f9fa54ff6a44b81cf647469592444af0872b5ecd7444df7d"
  license "GPL-2.0-or-later"
  head "https://github.com/cbxbiker61/cdargs.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "7276e0e92053255d34a6ab190a36dbbc58154253ba76d69f61f224d435c2675a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5be93566bc13d241d79bfa4c097b9a460750d889864bab0ee4276bd021a10f90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fed4d372bf68ed5208d3ea9a33934d90089839d309da6600377430af6682c2a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48b0cc0d5f0f06a74cb14d049f2cb4540be4e14d3e6a8e1b651ff64a34c249ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc63406b9216e6ae1ed24d3e7840776919dd1ad9a566610544fcf3c3520461b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb52b8d939ea7fde7c8579710b1bad8617e987214f2bfb730300b2e761ebf4dd"
    sha256 cellar: :any_skip_relocation, sonoma:         "ddc21725211421991e9335eec785ca97fde89ceb4840942d46dd2238d426277e"
    sha256 cellar: :any_skip_relocation, ventura:        "86be7bd36de93c3cd56ab18d4b4887a25abe3ece14e85fcf55867e73f453c586"
    sha256 cellar: :any_skip_relocation, monterey:       "8ab5eb91d90bb095fac13138ae4d86bd641075608aa173545fcca1c08f01bea1"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c2ee17afed909adb4511fbbd7521e0cc4a852fd383f94735f1de76e63ffeeeb"
    sha256 cellar: :any_skip_relocation, catalina:       "0a40505138d5465211cc963f438683e38b88518b9f854e58b75d245e7a6fcd16"
    sha256                               arm64_linux:    "2ad0944191220f6159c473279b6575743b2516589d835031c7bd914698dc1b93"
    sha256                               x86_64_linux:   "064d2b42b2a03248b41e077184e0244c28b65b7b0a7fab0711f4c9725fce3ba1"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  uses_from_macos "ncurses"

  # fixes zsh usage using the patch provided at the cdargs homepage
  # (See https://www.skamphausen.de/cgi-bin/ska/CDargs)
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/cdargs/1.35.patch"
    sha256 "adb4e73f6c5104432928cd7474a83901fe0f545f1910b51e4e81d67ecef80a96"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    rm Dir["contrib/Makefile*"]
    prefix.install "contrib"
    bash_completion.install_symlink "#{prefix}/contrib/cdargs-bash.sh"
  end

  def caveats
    <<~EOS
      Support files for bash, tcsh, and emacs have been installed to:
        #{prefix}/contrib
    EOS
  end

  test do
    system bin/"cdargs", "--version"
  end
end
