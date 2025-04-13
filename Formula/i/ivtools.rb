class Ivtools < Formula
  desc "X11 vector graphic servers"
  homepage "https://github.com/vectaport/ivtools"
  url "https://github.com/vectaport/ivtools/archive/refs/tags/ivtools-2.1.1.tar.gz"
  sha256 "4fa680b9d0fd2af610e9012258e150249d9a8abbc3b1f65eb17d01c959142cfc"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_sequoia: "b27e3ccddafd5fc89c69fb691f636e16dc83cd351371c60fdd63d8c1f6983b83"
    sha256 arm64_sonoma:  "cd85d4ab27e43fadb3bb79a7fa5bb4744ba312a1dc3f0e7143eba3bacc948bc1"
    sha256 arm64_ventura: "70ffb6c9ade79c815e2b1e06d8b4e867bcd9babda7b77faa9f1d3919e656621c"
    sha256 sonoma:        "828070545c2e66472fade42f8e22b154f153a7a38023783562b87a05798112f5"
    sha256 ventura:       "aa7085f4e2a50ed9abf9846b9b16ea456abdddf774e0dd20acdcfb3b7d23ca85"
    sha256 arm64_linux:   "c9098f94cb6fd159321462faa367524b483774f1e21db26a14d0076d79aa6e12"
    sha256 x86_64_linux:  "d09f4ad1563dfd467eeb0991c8289cc5fdda69bb3a749a798d3134f915de3af4"
  end

  depends_on "ace"
  depends_on "libx11"
  depends_on "libxext"

  on_linux do
    on_arm do
      depends_on "automake" => :build
    end
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
