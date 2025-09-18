class Hstr < Formula
  desc "Bash and zsh history suggest box"
  homepage "https://github.com/dvorka/hstr"
  url "https://github.com/dvorka/hstr/archive/refs/tags/3.1.tar.gz"
  sha256 "e5293d4fe2502662f19c793bef416e05ac020490218e71c75a5e92919c466071"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "60932e5b5653859d9c2b7c74426edc047719ba50cd7b2071503636c2c0a0b40a"
    sha256 cellar: :any,                 arm64_sequoia:  "76e0d87760c6519a63d6cf0e7719b4683292572ac923e29b9f366d67deae37df"
    sha256 cellar: :any,                 arm64_sonoma:   "72781912003352405419c5a62748a8a19807b5ac77691013fb59fe54084617e7"
    sha256 cellar: :any,                 arm64_ventura:  "fc49b795a9a4182c314a299e959d3307a90e0dcd349f7a177f4990177fdbbd2d"
    sha256 cellar: :any,                 arm64_monterey: "db9cc4ec008f0de26ed8804a27497ab85e0ef5130cbaff99d36b7a9e290484ed"
    sha256 cellar: :any,                 arm64_big_sur:  "27b892cd3e184775eb18ad1538f102470d9ea46f2b12aaeae0c9369eb7d10ae6"
    sha256 cellar: :any,                 sonoma:         "8305545469de8189ba8bf0ab46f91bd055beecdb95632e7227f25b3e247963e9"
    sha256 cellar: :any,                 ventura:        "dab8c56dc9d4a3c14b97a16e4b7640e911fc263cdf8c0d051ef7b2f5914c5d68"
    sha256 cellar: :any,                 monterey:       "4d612879fc6066185b3b1cf9f334f55dfafbab73295bc041d3edc8fd1a2d0be7"
    sha256 cellar: :any,                 big_sur:        "196bd9dcd789830ca5ea6f3ee94ba43bf3ec0574cbc21196c0461a20b1b34757"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7e90597a53137de8a61011df6b8e453657a4e679e42f1f98da5e9e29259c948f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f3e5c6ea14b17a5e83263bc1df77201cf44eee579f2663656c9912893de7df0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "readline"

  uses_from_macos "ncurses"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    ENV["HISTFILE"] = testpath/".hh_test"
    (testpath/".hh_test").write("test\n")
    assert_match "test", shell_output("#{bin}/hh -n").chomp
  end
end
