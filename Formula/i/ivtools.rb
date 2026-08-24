class Ivtools < Formula
  desc "X11 vector graphic servers"
  homepage "https://github.com/vectaport/ivtools"
  url "https://github.com/vectaport/ivtools/archive/refs/tags/ivtools-2.1.1.tar.gz"
  sha256 "4fa680b9d0fd2af610e9012258e150249d9a8abbc3b1f65eb17d01c959142cfc"
  license "MIT"
  revision 6

  livecheck do
    url :stable
    regex(/^ivtools-(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "db0d98455a5b700918da4ac97302909a9deb87c41715f36021b6f4d9e1199afe"
    sha256 arm64_sequoia: "abf1527eccf79ff0798f72a67c17e4410883a1054264c8ba9e23c8eb667c9e5f"
    sha256 arm64_sonoma:  "23e8da85985c1151e96f7fac3364009a3f46c93f5ad6e4a31796803ed662cfe3"
    sha256 sonoma:        "9200ba39a84bb80ea1f3553d87922fd3b2cf77cd184b3662c30d93efb39ed1f8"
    sha256 arm64_linux:   "4a334dbf786378fff4c7b21f29ee90ac0508e279fd73de4ceb2e0dec58712d54"
    sha256 x86_64_linux:  "6567557ed5df4cd228f3d16934536a9cda6c72d1d9975e1151d3ab50a2ce77bd"
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
  patch do
    url "https://github.com/vectaport/ivtools/commit/6c4f2afb11d76fc34fb918c2ba53c4c4c5db55ae.patch?full_index=1"
    sha256 "5aaa198d2c2721d30b1f31ea9817ca7fbf1a518dde782d6441cf5946a7b83ee2"
    type :backport
    resolves "https://github.com/vectaport/ivtools/pull/25"
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
