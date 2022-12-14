class GnuComplexity < Formula
  desc "Measures complexity of C source"
  homepage "https://www.gnu.org/software/complexity"
  url "https://ftp.gnu.org/gnu/complexity/complexity-1.13.tar.xz"
  mirror "https://ftpmirror.gnu.org/complexity/complexity-1.13.tar.xz"
  sha256 "80a625a87ee7c17fed02fb39482a7946fc757f10d8a4ffddc5372b4c4b739e67"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "069c43183f32681bc060d6cd22a38c2aed732c7e3ca80eb5eaa952e70b73b151"
    sha256 cellar: :any,                 arm64_monterey: "8993252129e6f15eb99fad254ad51f796c525c48294a85b5ae203c10b4310689"
    sha256 cellar: :any,                 arm64_big_sur:  "ae738fac097e00b3fec0355072eab9622f5d29f78ae465b25bee554916e07fec"
    sha256 cellar: :any,                 ventura:        "c3e57e932b3ad175eb39924e62977e8210fd606a1a6fe768a92fa39bf3eeb05d"
    sha256 cellar: :any,                 monterey:       "a593ca4a28d36625f6d6688a54eef22876067dae4d2c943294618b2a996fc6ad"
    sha256 cellar: :any,                 big_sur:        "260cd84aa3d6cf2395aff51aaea06bfb6d1729b5a9c8423ad4c9de1a7ec0c195"
    sha256 cellar: :any,                 catalina:       "8a83c1ada362279b8fbe66addd9fb0d646cb90f8c936959c7923a546f9cd0770"
    sha256 cellar: :any,                 mojave:         "25474f8be313534736f5ccbe1c707969606ca3fa7360079df0cc8879cde0fbbb"
    sha256 cellar: :any,                 high_sierra:    "94558c250d55d6d1c83e682d38481b0d75b12850d46e00dacdf81744be288229"
    sha256 cellar: :any,                 sierra:         "3ea1d968a1eaa2ce6655fa8e33b721af3cd631075f960c6595ca68aecd0972c7"
    sha256 cellar: :any,                 el_capitan:     "89b7043d1f51fc6ff7a1e96f8ed23bbac73bbb7196a04851a2cf29475b0803f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bc40505bf964f2ac7ef30d2f65c8180832e709c49cf6872b8651caf6a84b1a1"
  end

  # Drop `autoconf` and `automake` when the patch is removed.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "autogen"

  # Fix build problem in doc. Borrowed from Debian.
  patch do
    url "https://salsa.debian.org/debian/complexity/-/raw/69a7b9d27eb5c2ba8aa43966518971df74d55657/debian/patches/01_fix_autobuild.patch"
    sha256 "3c2403be83ae819bbdfe7d1b0f14e2637d504387d1237f15b24e149cd66f56b1"
  end

  def install
    # Fix errors in opts.h. Borrowed from Debian:
    # https://salsa.debian.org/debian/complexity/-/blob/master/debian/rules
    cd "src" do
      system "autogen", "opts.def"
    end

    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      void free_table(uint32_t *page_dir) {
          // The last entry of the page directory is reserved. It points to the page
          // table itself.
          for (size_t i = 0; i < PAGE_TABLE_SIZE-2; ++i) {
              uint32_t *page_entry = (uint32_t*)GETADDRESS(page_dir[i]);
              for (size_t j = 0; j < PAGE_TABLE_SIZE; ++j) {
                  uintptr_t addr = (i<<20|j<<12);
                  if (addr == VIDEO_MEMORY_BEGIN ||
                          (addr >= KERNEL_START && addr < KERNEL_END)) {
                      continue;
                  }
                  if ((page_entry[j] & PAGE_PRESENT) == 1) {
                      free_frame(page_entry[j]);
                  }
              }
          }
          free_frame((page_frame_t)page_dir);
      }
    EOS
    system bin/"complexity", "-t", "3", "./test.c"
  end
end
