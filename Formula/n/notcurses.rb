class Notcurses < Formula
  desc "Blingful character graphics/TUI library"
  homepage "https://nick-black.com/dankwiki/index.php/Notcurses"
  url "https://github.com/dankamongmen/notcurses/archive/refs/tags/v3.0.11.tar.gz"
  sha256 "acc8809b457935a44c4dcaf0ee505ada23594f08aa2ae610acb6f2355afd550a"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sequoia: "cea8b898c7b0f418b0e4e04eec9bf8162e0afae71899f8c82b8c7adf8357ee57"
    sha256 arm64_sonoma:  "65d1296ea17da0391d1d690c070875324902474d6ee64de058cdb484789aa98e"
    sha256 arm64_ventura: "13a212cc32d0930a9b0c8b41198cd489f43125c0b689458a0e6ed44d4238bc56"
    sha256 sonoma:        "6c8d86dbfa98a3860900bc0392150b7d016982ecd6d35c0409b541b26432a0a1"
    sha256 ventura:       "a669eb37e5d9fdf420e36364bfb221ffaca94660418f138ab83fe6a94307d158"
    sha256 x86_64_linux:  "16c22a7a7fb8970661e4454817e20a2d546de42925e9a070ce8ad88cd889474f"
  end

  depends_on "cmake" => :build
  depends_on "doctest" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "libdeflate"
  depends_on "libunistring"
  depends_on "ncurses"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # current homebrew CI runs with TERM=dumb. given that Notcurses explicitly
    # does not support dumb terminals (i.e. those lacking the "cup" terminfo
    # capability), we expect a failure here. all output will go to stderr.
    assert_empty shell_output(bin/"notcurses-info", 1)
  end
end
