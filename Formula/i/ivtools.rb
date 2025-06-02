class Ivtools < Formula
  desc "X11 vector graphic servers"
  homepage "https://github.com/vectaport/ivtools"
  url "https://github.com/vectaport/ivtools/archive/refs/tags/ivtools-2.1.1.tar.gz"
  sha256 "4fa680b9d0fd2af610e9012258e150249d9a8abbc3b1f65eb17d01c959142cfc"
  license "MIT"
  revision 2

  bottle do
    sha256 arm64_sequoia: "8e490b72b8f0d4ab14b666c5a0a5c1e7fb0a1ef009f16e68a287cdbe6baabc5e"
    sha256 arm64_sonoma:  "089d3a1a83e7ab861c372e8624d4f5c1cf30170395c880527f5e40452f9c3332"
    sha256 arm64_ventura: "f0e1133904428f8b10565f5429aee3e97dd525c25be3dc79c6d93b8fbff1bc4a"
    sha256 sonoma:        "ca9aeb46127c39266456e76adf83ab9ebea763512189525c0c87b1495d605055"
    sha256 ventura:       "5634c8c5cc630b4320e6b087451878491050fb0e03d620870caa1688a31ae3ac"
    sha256 arm64_linux:   "25d8f1dfb90b4a732d8c01f8320ed8a4e3ed4548bd4d73fa730cf9eb7d1a42c7"
    sha256 x86_64_linux:  "cfa432a860ad12324624892ce24da9b83092bba19212e7e435c40cac8b1f65eb"
  end

  depends_on "ace"
  depends_on "libx11"
  depends_on "libxext"

  on_linux do
    on_arm do
      depends_on "automake" => :build
    end
  end

  # Fix to error: unknown type name '_LIBCPP_INLINE_VISIBILITY' and '_VSTD'
  # PR ref: https://github.com/vectaport/ivtools/pull/25
  patch do
    url "https://github.com/vectaport/ivtools/commit/6c4f2afb11d76fc34fb918c2ba53c4c4c5db55ae.patch?full_index=1"
    sha256 "5aaa198d2c2721d30b1f31ea9817ca7fbf1a518dde782d6441cf5946a7b83ee2"
  end

  def install
    # Workaround for ancient config files not recognizing aarch64 linux.
    if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      %w[config.guess config.sub].each do |fn|
        cp Formula["automake"].share/"automake-#{Formula["automake"].version.major_minor}"/fn, "src/scripts/#{fn}"
      end
    end

    cp "Makefile.orig", "Makefile"
    ace = Formula["ace"]
    args = %W[--mandir=#{man} --with-ace=#{ace.opt_include} --with-ace-libs=#{ace.opt_lib}]
    system "./configure", *std_configure_args, *args
    system "make"
    system "make", "install"

    # Conflicts with dialog
    mv man3/"Dialog.3", man3/"Dialog_ivtools.3"

    # Delete unneeded symlink to libACE on Linux which conflicts with ace.
    rm lib/"libACE.so" unless OS.mac?
  end

  test do
    system bin/"comterp", "exit(0)"
  end
end
