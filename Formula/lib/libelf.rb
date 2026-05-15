class Libelf < Formula
  desc "ELF object file access library"
  # Original upstream is gone https://web.archive.org/web/20181111033959/www.mr511.de/software/english.html
  homepage "https://fossies.org/linux/misc/old/libelf-0.8.13.tar.gz/"
  url "https://www.mirrorservice.org/sites/ftp.netbsd.org/pub/pkgsrc/distfiles/libelf-0.8.13.tar.gz"
  mirror "https://fossies.org/linux/misc/old/libelf-0.8.13.tar.gz"
  sha256 "591a9b4ec81c1f2042a97aa60564e0cb79d041c52faa7416acb38bc95bd2c76d"
  license "LGPL-2.0-or-later"
  revision 1

  livecheck do
    skip "No longer developed or maintained"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "03f9c0c79cd12a3a0ab46052037033ef676960079c27be5aca7072abe80cc4a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4f4135950b4b898f046e748266d309126a4c87e0e86a19d476192f9619660819"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b5db356e6f8dc983b40424a17c9b73bfcbb442d08a6db8e952744b55aa53bb6e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "839fa934a24ba7bff4bd8ed5d8e3440cd70db7027fa2b79201c32469d0947877"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3987585b99efe287bfe353b420ba423057e6bfb3a27d543f5f0bfe13f76ef42f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd7a08bb9750a466bfc18473a61df2095b6d106ffb72f4ed4af706c7385b4202"
    sha256 cellar: :any_skip_relocation, sonoma:         "d40b4bca1b19eace612dc6fd980cd55a94e6a476434ade2db012ef854778bfb7"
    sha256 cellar: :any_skip_relocation, ventura:        "fdd2375a9f0931864f46148881455d90d4d4bb91c072d16861c3129168e27871"
    sha256 cellar: :any_skip_relocation, monterey:       "f7dd2aac1032b020ee90c997fb82f771ff686efbc481c4844c16b149d379a51a"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b69f55ccec2aa1bfa85bef3fe071077fe281e2bc63dc33cc4344a1cc02e1e26"
    sha256 cellar: :any_skip_relocation, catalina:       "b7635245b64cc7d857c92191c40877cba96871d07f4749f620bc96c63cd2635e"
  end

  # Commented out while this formula still has dependents.
  # deprecate! date: "2019-05-17", because: :unmaintained # and upstream site is gone

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  # `libelf` should never be used on Linux as `elfutils` is available.
  depends_on :macos

  def install
    # Workaround for ancient config files not recognising aarch64 macos.
    am = Formula["automake"]
    am_share = am.opt_share/"automake-#{am.version.major_minor}"
    %w[config.guess config.sub].each do |fn|
      cp am_share/fn, fn
    end

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-compat", *std_configure_args
    # Use separate steps; there is a race in the Makefile.
    system "make"
    system "make", "install"
  end

  test do
    elf_content =  "7F454C460101010000000000000000000200030001000000548004083" \
                   "4000000000000000000000034002000010000000000000001000000000000000080040" \
                   "80080040874000000740000000500000000100000B00431DB43B96980040831D2B20CC" \
                   "D8031C040CD8048656C6C6F20776F726C640A"
    File.binwrite(testpath/"elf", [elf_content].pack("H*"))

    (testpath/"test.c").write <<~C
      #include <gelf.h>
      #include <fcntl.h>
      #include <stdio.h>

      int main(void) {
        GElf_Ehdr ehdr;
        int fd = open("elf", O_RDONLY, 0);
        if (elf_version(EV_CURRENT) == EV_NONE) return 1;
        Elf *e = elf_begin(fd, ELF_C_READ, NULL);
        if (elf_kind(e) != ELF_K_ELF) return 1;
        if (gelf_getehdr(e, &ehdr) == NULL) return 1;
        printf("%d-bit ELF\\n", gelf_getclass(e) == ELFCLASS32 ? 32 : 64);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}/libelf",
                   "-lelf", "-o", "test"
    assert_match "32-bit ELF", shell_output("./test")
  end
end
