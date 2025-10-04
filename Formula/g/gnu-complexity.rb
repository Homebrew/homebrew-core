class GnuComplexity < Formula
  desc "Measures complexity of C source"
  homepage "https://www.gnu.org/software/complexity/"
  url "https://ftpmirror.gnu.org/gnu/complexity/complexity-1.13.tar.xz"
  mirror "https://ftp.gnu.org/gnu/complexity/complexity-1.13.tar.xz"
  sha256 "80a625a87ee7c17fed02fb39482a7946fc757f10d8a4ffddc5372b4c4b739e67"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "edf8e7fe3a3c8d707ff63dbd5d5ef0226653cd76bf7c6d5faf077f09f1fb2b31"
    sha256 cellar: :any,                 arm64_sequoia:  "cd060b26ae921fe515fb597c86e07eb82c0cad595d8eab8547cd421db5a249e3"
    sha256 cellar: :any,                 arm64_sonoma:   "8e32f6384e57c2e21cce940fc39b2be2257b0a200367a48f85aee626988a9863"
    sha256 cellar: :any,                 arm64_ventura:  "c61d3b1a378d7debac6a79e092b3828b68b455d0b555edcb02129b34945947b1"
    sha256 cellar: :any,                 arm64_monterey: "d88523c95f66d61eab621059d46a31cae7da8964042c28499e49def45ddb6d40"
    sha256 cellar: :any,                 arm64_big_sur:  "7561dae8dcc2422a456727c8fc7b9e8e2719fca7934f26118c32bb455f376ef5"
    sha256 cellar: :any,                 sonoma:         "0b3ec86fc33aa631f44dd91525ff27e9b2c992e43acbf0ef1a1e71b4a78763be"
    sha256 cellar: :any,                 ventura:        "4bef537bbe2199465336c8f1dcbd0c862564eb13cf2680d53671075cd6bda92e"
    sha256 cellar: :any,                 monterey:       "288719f321641b768497edfae38f1ac88499b5274ce8ada8ea1c5cd30239078c"
    sha256 cellar: :any,                 big_sur:        "82574a778a6b6ba218cd98fbd173bb7c15f4253fd871349abf8c1c322cbe99c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "412f37fba031fc1b45d13fb61d9a025af47633ffc64852bd2f450d08be3dadde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "623e40ffaa4b67fb049c25a3cb3a781366fa19b316207b5f50d68ecccbb839dd"
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
    odie "check if autoreconf line can be removed" if version > "1.13"
    # regenerate since the files were generated using automake 1.16.1
    system "autoreconf", "--force", "--install", "--verbose"

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
    (testpath/"test.c").write <<~C
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
    C
    system bin/"complexity", "-t", "3", "./test.c"
  end
end
