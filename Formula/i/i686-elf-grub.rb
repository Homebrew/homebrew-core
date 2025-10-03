class I686ElfGrub < Formula
  desc "GNU GRUB bootloader for i686-elf"
  homepage "https://savannah.gnu.org/projects/grub"
  url "https://ftpmirror.gnu.org/gnu/grub/grub-2.12.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/gnu/grub/grub-2.12.tar.xz"
  sha256 "f3c97391f7c4eaa677a78e090c7e97e6dc47b16f655f04683ebd37bef7fe0faa"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "1d2739ccc6236e10e07a6877bd36869d3289b295cb06329c2ed5c028be968421"
    sha256 arm64_sequoia: "16923a4a52103eb6468129a574eb7b3c85d771adb37773d8e2a6850225805931"
    sha256 arm64_sonoma:  "ceb84b9c359fbb659e7b355065513d605bd013fde1a642c4c9838d08499e5959"
    sha256 arm64_ventura: "acfedbdc6b331ec2a1257cb55303befd965280978678c2f6e34f9dd45d6bd7e6"
    sha256 sonoma:        "f72297ff2a716b0347a300c27b8ea3e0f40090b243b5500f0fe2c824de003ac3"
    sha256 ventura:       "154a14a89653bdf2f8a521ae150c8e998e2bd51f2d9bf78560509b4a2d9791e8"
    sha256 arm64_linux:   "d210e360f1529d9d5019a07c703d312155a3d485413df86ab13599240bdbdd39"
    sha256 x86_64_linux:  "f6f03a027b9c884fedcc5c9c3fb85599a4d279ea38263afbb64824fb7148db84"
  end

  depends_on "gawk" => :build
  depends_on "help2man" => :build
  depends_on "i686-elf-binutils" => :build
  depends_on "i686-elf-gcc" => [:build, :test]
  depends_on "objconv" => :build
  depends_on "texinfo" => :build
  depends_on "gettext"
  depends_on "xorriso"
  depends_on "xz"
  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "python" => :build

  def target
    "i686-elf"
  end

  def install
    ENV.append_to_cflags "-Wno-error=incompatible-pointer-types"
    ENV["PATH"]=prefix/"opt/gawk/libexec/gnubin:#{ENV["PATH"]}"

    touch buildpath/"grub-core/extra_deps.lst"

    mkdir "build" do
      args = %W[
        --disable-werror
        --target=#{target}
        --prefix=#{prefix/target}
        --bindir=#{bin}
        --libdir=#{lib/target}
        --with-platform=pc
        --program-prefix=#{target}-
      ]

      system "../configure", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"boot.c").write <<~C
      __asm__(
        ".align 4\\n"
        ".long 0x1BADB002\\n"
        ".long 0x0\\n"
        ".long -(0x1BADB002 + 0x0)\\n"
      );
    C
    system Formula["#{target}-gcc"].bin/"#{target}-gcc", "-c", "-o", "boot", "boot.c"
    system bin/"#{target}-grub-file", "--is-x86-multiboot", "boot"
  end
end
