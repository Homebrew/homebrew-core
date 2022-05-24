class GnuComplexity < Formula
  desc "Measures complexity of C source"
  homepage "https://www.gnu.org/software/complexity"
  url "https://ftp.gnu.org/gnu/complexity/complexity-1.10.tar.xz"
  mirror "https://ftpmirror.gnu.org/complexity/complexity-1.10.tar.xz"
  sha256 "6d378a3ef9d68938ada2610ce32f63292677d3b5c427983e8d72702167a22053"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8993252129e6f15eb99fad254ad51f796c525c48294a85b5ae203c10b4310689"
    sha256 cellar: :any,                 arm64_big_sur:  "ae738fac097e00b3fec0355072eab9622f5d29f78ae465b25bee554916e07fec"
    sha256 cellar: :any,                 monterey:       "a593ca4a28d36625f6d6688a54eef22876067dae4d2c943294618b2a996fc6ad"
    sha256 cellar: :any,                 big_sur:        "260cd84aa3d6cf2395aff51aaea06bfb6d1729b5a9c8423ad4c9de1a7ec0c195"
    sha256 cellar: :any,                 catalina:       "8a83c1ada362279b8fbe66addd9fb0d646cb90f8c936959c7923a546f9cd0770"
    sha256 cellar: :any,                 mojave:         "25474f8be313534736f5ccbe1c707969606ca3fa7360079df0cc8879cde0fbbb"
    sha256 cellar: :any,                 high_sierra:    "94558c250d55d6d1c83e682d38481b0d75b12850d46e00dacdf81744be288229"
    sha256 cellar: :any,                 sierra:         "3ea1d968a1eaa2ce6655fa8e33b721af3cd631075f960c6595ca68aecd0972c7"
    sha256 cellar: :any,                 el_capitan:     "89b7043d1f51fc6ff7a1e96f8ed23bbac73bbb7196a04851a2cf29475b0803f7"
    sha256 cellar: :any,                 yosemite:       "35a8ac468a12565af95b82c75d6b45c9c55c27fa769244f0bd87ec69b10742b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bc40505bf964f2ac7ef30d2f65c8180832e709c49cf6872b8651caf6a84b1a1"
  end

  depends_on "autogen"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
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
