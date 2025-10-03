class Bitwise < Formula
  desc "Terminal based bit manipulator in ncurses"
  homepage "https://github.com/mellowcandle/bitwise"
  url "https://github.com/mellowcandle/bitwise/releases/download/v0.50/bitwise-v0.50.tar.gz"
  sha256 "806271fa5bf31de0600315e8720004a8f529954480e991ca84a9868dc1cae97e"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "9f6712da2de2e93861c008540f524f5b60be33054db0acb064d82a26322c361d"
    sha256 cellar: :any,                 arm64_sequoia:  "d7659a60e6cad87bc0dd72921475005c50340e66d7a6ba822a5769a67df1b91d"
    sha256 cellar: :any,                 arm64_sonoma:   "923c4828ff104f940038b9d6969759b08d90a3d2c89cb1c0e31b913a2d38769e"
    sha256 cellar: :any,                 arm64_ventura:  "85b482536f160a726ccf996c7653763a19c43b5b4926c8da4af4bb0b01ff63ca"
    sha256 cellar: :any,                 arm64_monterey: "7b2980226d0d6d231bf41898bbadd6c18a838bee766aa62dfff1c451d8c0357a"
    sha256 cellar: :any,                 arm64_big_sur:  "92f12631e0740195ad3cf87b0a320288d6d27523651568575d3dedb4a02a0705"
    sha256 cellar: :any,                 sonoma:         "66b9022c3207ba8c0b9b9b3a530dfd1403d9fc3ed4c5e991ee01d7d3aafb3635"
    sha256 cellar: :any,                 ventura:        "7b67229824c3f0e7b1ff3f3e1cfbf11f8f0b8f6dec64a75e010e81f1e8e32fce"
    sha256 cellar: :any,                 monterey:       "5f880e578cbd7558572c25c9f5c66a674e0e0547f1bc7e8cee33e4869bb39228"
    sha256 cellar: :any,                 big_sur:        "560ee93626732de20fa8d5ca16058c92f26383a497e8218029ecbe377cda5602"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "576e3966940ee9afff289f542a29073600a1b131c234e6ef49c0b59eb2cde5c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "843a3614b4b1ce32529429588fbc60289bfdf91086658666c850be7f88c1baca"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    assert_match "0 0 1 0 1 0 0 1", shell_output("#{bin}/bitwise --no-color '0x29A >> 4'")
  end
end
