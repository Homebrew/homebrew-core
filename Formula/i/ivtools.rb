class Ivtools < Formula
  desc "X11 vector graphic servers"
  homepage "https://github.com/vectaport/ivtools"
  url "https://github.com/vectaport/ivtools/archive/refs/tags/ivtools-2.1.1.tar.gz"
  sha256 "4fa680b9d0fd2af610e9012258e150249d9a8abbc3b1f65eb17d01c959142cfc"
  license "MIT"
  revision 7

  livecheck do
    url :stable
    regex(/^ivtools-(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "c0fb5cf339425f2c81f96b03e40aca7142546147f6db26341de06dd7fbf4fc62"
    sha256 arm64_tahoe:       "0ba68cb5a4d04966ae25bd30ada3ff3cddb192e9f3927792f41a528f96bcaa80"
    sha256 arm64_sequoia:     "750fb2fc78a73d9fbe7282ab27f514e142d77655dda84d2949bec51fb1838bd3"
    sha256 arm64_linux:       "bfd8ab978398f976d130f3b484337b98d09b856e47b27c31df9b6c3f91b7075e"
    sha256 x86_64_linux:      "ebd182c4f41f0712a0b6cf5cfa4970e088c32ecad89166b9a3e93dfc3eda9411"
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

  deny_network_access!

  def install
    # Workaround for ancient config files not recognizing aarch64 linux.
    if OS.linux? && Hardware::CPU.arm64?
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
