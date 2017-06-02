class GnuComplexity < Formula
  desc "Measures complexity of C source"
  homepage "https://www.gnu.org/software/complexity"
  url "https://ftp.gnu.org/gnu/complexity/complexity-1.10.tar.xz"
  mirror "https://ftpmirror.gnu.org/complexity/complexity-1.10.tar.xz"
  sha256 "6d378a3ef9d68938ada2610ce32f63292677d3b5c427983e8d72702167a22053"

  bottle do
    cellar :any
    sha256 "3ea1d968a1eaa2ce6655fa8e33b721af3cd631075f960c6595ca68aecd0972c7" => :sierra
    sha256 "89b7043d1f51fc6ff7a1e96f8ed23bbac73bbb7196a04851a2cf29475b0803f7" => :el_capitan
    sha256 "35a8ac468a12565af95b82c75d6b45c9c55c27fa769244f0bd87ec69b10742b1" => :yosemite
    sha256 "5aba079cba5a07f3e754019cd11ed767ab65cd6c4dcef33eea9e94b94bae19eb" => :mavericks
  end

  depends_on "autogen" => :run
  depends_on "gcc" if MacOS.version <= :mavericks

  # error: use of undeclared identifier '__noreturn__'
  fails_with :clang if MacOS.version <= :mavericks

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
