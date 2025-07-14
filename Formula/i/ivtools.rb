class Ivtools < Formula
  desc "X11 vector graphic servers"
  homepage "https://github.com/vectaport/ivtools"
  url "https://github.com/vectaport/ivtools/archive/refs/tags/ivtools-2.1.1.tar.gz"
  sha256 "4fa680b9d0fd2af610e9012258e150249d9a8abbc3b1f65eb17d01c959142cfc"
  license "MIT"
  revision 3

  bottle do
    sha256 arm64_sequoia: "7262323366f868c3b439fe7926a4ff4c82f4b9b4a7dc18105cdfeffa26406dc9"
    sha256 arm64_sonoma:  "e507c775197c8d39f0c13ed77571e1acebc9dbb56632360a6a1a4d8c3ec48beb"
    sha256 arm64_ventura: "0c8d64c50a1f72143c5d98612e711e494ba99ba3a5eb6513931bd3cf1ae632c4"
    sha256 sonoma:        "9c69b393d8bfc1437fc7cdccc7a9d6aa4d694a116a7758286d7d430cef45f3b5"
    sha256 ventura:       "1e920e418388137fded7edba4556dfb6ba1ba97b4b0f343f6e7ff0b1fbe7af11"
    sha256 arm64_linux:   "0dd7793c88f54942638335dd7518f37572f25948224c4f5e1aac3203c0f4e8ec"
    sha256 x86_64_linux:  "e8b3d3a65e96abbc4ab804626390838ae1b5b518255bdedc50b4505c64430fe9"
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
