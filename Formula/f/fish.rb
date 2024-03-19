class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/3.7.1/fish-3.7.1.tar.xz"
  sha256 "614c9f5643cd0799df391395fa6bbc3649427bb839722ce3b114d3bbc1a3b250"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  pour_bottle? only_if: :default_prefix

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "df77766a3e20b75b220364befbb0a8abea19662e471fb9c42bc0d8746ae00570"
    sha256 cellar: :any,                 arm64_ventura:  "1968642c9fec6da5d16cb649d54c66bc9d500e5b91c43bd2c4b8098f71c0b983"
    sha256 cellar: :any,                 arm64_monterey: "80e5c51fe504bef8785c472424ea8a176536b0d56f3b52eb79a1d1b6ac7739f3"
    sha256 cellar: :any,                 sonoma:         "4a123e4be4fb992fe9d0e4473d7be2f8389616b12b0d081db82e5bae395e57cf"
    sha256 cellar: :any,                 ventura:        "00de65841e80b4acd781999a03f2fe38d32a1aa10d8b4432af832905ec26c2d8"
    sha256 cellar: :any,                 monterey:       "0bea9245a7565601af76d43c3cb26b7ce500b68a9326df6cd4d0d6cd49d91e12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8b18b643a3cf68af82ebeb260dde9be24bac67b5e48b44cce1799777eab4e96"
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
