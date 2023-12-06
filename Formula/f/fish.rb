class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://github.com/fish-shell/fish-shell/releases/download/3.6.4/fish-3.6.4.tar.xz"
  sha256 "0f3f610e580de092fbe882c8aa76623ecf91bb16fdf0543241e6e90d5d4bc393"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  pour_bottle? only_if: :default_prefix

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9fd37026489e9daac1ce77284d05e9f7af0a4751c3dd97828112b58e71c10dd8"
    sha256 cellar: :any,                 arm64_ventura:  "0529f97d5e5a07308ca8bedd29b038cf0050aebc546f05efa59aab292fa17c1c"
    sha256 cellar: :any,                 arm64_monterey: "d60d08d8bca99b3bd96f2f9c226b483ca64d31940521ef5036da289ab82071f9"
    sha256 cellar: :any,                 sonoma:         "81610211da71108ad9794f3bb3ee2a3db7fe43e08108c50161fccf71e3a87e9f"
    sha256 cellar: :any,                 ventura:        "31f67946b37763f9abf17cdbf652a23747eabe49bab6f535c9706cd94b939fd2"
    sha256 cellar: :any,                 monterey:       "7c969d93c021c32c671695bc0e5248e63e75344e5d2e2c58f2758d3abc6c1edd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0faad1c9fbeb7737b67fba61450fe5d4fe881559d0a4e56b5f654aba32f12b85"
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
                    "-DCMAKE_INSTALL_DATADIR=share"
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
