class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/3.6.1/fish-3.6.1.tar.xz"
  sha256 "55402bb47ca6739d8aba25e41780905b5ce1bce0a5e0dd17dca908b5bc0b49b2"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  pour_bottle? only_if: :default_prefix

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "70fdce88ebe0aa417321a41fceb2b1323c6a1bcca50951efbc2d47a0f887640a"
    sha256 cellar: :any,                 arm64_ventura:  "571264d1c65ebb98496384a27239a938098d87f6fd3177394d82b915a0c499fc"
    sha256 cellar: :any,                 arm64_monterey: "b8eeb9a400c53d767264c7df2aa5174ed52515347e1c47210b2a51dafc086654"
    sha256 cellar: :any,                 arm64_big_sur:  "d01c4f24ea68d3790664f33d22758fe475f2dd69b547c4dd57d01ba4b2e33594"
    sha256 cellar: :any,                 sonoma:         "83a1807f04308a2c7dfe006156b8018c90e17d9df927b20eddf1b1925c60e365"
    sha256 cellar: :any,                 ventura:        "2af848db0107a294a3fcb9adb00242ace9428a8ff3d7638998f4a7c3340d64b5"
    sha256 cellar: :any,                 monterey:       "f2150d371dbb4d63c93a5de2b7179ad219be124d3a33d6ba8c01d1064d209c53"
    sha256 cellar: :any,                 big_sur:        "f6377a53c4bc817e7655b9f6af6664fd1595043bda7dbde9eca4e16e47a58465"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67618246603a384573a202679a2b0169601e6011aa110fe96b536dc40fa95e33"
  end

  head do
    url "https://github.com/fish-shell/fish-shell.git", branch: "master"

    depends_on "rust" => :build
    depends_on "sphinx-doc" => :build
  end

  depends_on "cmake" => :build
  # Apple ncurses (5.4) is 15+ years old and
  # has poor support for modern terminals
  depends_on "ncurses"
  depends_on "pcre2"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}",
                    "-Dextra_functionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_functions.d",
                    "-Dextra_completionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_completions.d",
                    "-Dextra_confdir=#{HOMEBREW_PREFIX}/share/fish/vendor_conf.d"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def post_install
    (pkgshare/"vendor_functions.d").mkpath
    (pkgshare/"vendor_completions.d").mkpath
    (pkgshare/"vendor_conf.d").mkpath
  end

  test do
    system "#{bin}/fish", "-c", "echo"
  end
end
