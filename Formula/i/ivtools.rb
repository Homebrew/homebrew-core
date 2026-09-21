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
    rebuild 1
    sha256 arm64_golden_gate: "a69e428b1dbc6ba6dc7b1ba6b17f7a00c9a7666b09bf39f8afbae5861ca245c5"
    sha256 arm64_tahoe:       "67f1a46aca2f25c032fcffedb05c2cf2e28cb0603ec00858bfb722b5f538b6cb"
    sha256 arm64_sequoia:     "ac9a42927da7997644f40b872db459791f355dce97ce0a8ecba7c7616e0544fb"
    sha256 arm64_linux:       "92c32cef62a1a4df074ee5609da4a5dbec3ec44de778e0cd207dc2b556e44062"
    sha256 x86_64_linux:      "c35982cd34127344bdfa4c0f11d5e8aed2f64f2b9f8593b4827a7e9dddc99d84"
  end

  depends_on "ace"
  depends_on "libx11"
  depends_on "libxext"

  on_linux do
    on_arm do
      depends_on "automake" => :build
    end
  end

  # Drop the vendored libc++ `fstream` copy that macOS 27 SDK rejects as a redefinition of `basic_filebuf`
  patch do
    url "https://github.com/vectaport/ivtools/commit/df902bfd4bdf883455e65f3a251817193636e42b.patch?full_index=1"
    sha256 "e8a3cff8f5f8630634675d9acce44e11a7687c8e99bc99e85d3016879cc0f7f2"
    type :backport
    resolves "https://github.com/vectaport/ivtools/commit/df902bfd4bdf883455e65f3a251817193636e42b"
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
