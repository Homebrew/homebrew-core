class Ivtools < Formula
  desc "X11 vector graphic servers"
  homepage "https://github.com/vectaport/ivtools"
  url "https://github.com/vectaport/ivtools/archive/refs/tags/ivtools-2.1.1.tar.gz"
  sha256 "4fa680b9d0fd2af610e9012258e150249d9a8abbc3b1f65eb17d01c959142cfc"
  license "MIT"
  revision 4

  bottle do
    sha256 arm64_tahoe:   "0944ef622cdc4c71bad4d0aadfa3e0d515ac6bbcf9f72f545b114aad46ce740d"
    sha256 arm64_sequoia: "0d12a4d66b7366597a9ac6527476bbfbdbba40fc820f37b54a7f3f9470861dd6"
    sha256 arm64_sonoma:  "77c268d9d86a3ad6b4ad9d9cd80ba39be99d0d4a1546cf1edf1edc00e2060d6a"
    sha256 arm64_ventura: "1e39133890e0082eba7f12737eafaaecd374116e697c74b76d54f07851b79b07"
    sha256 sonoma:        "5cce5d74ed1e1661384a984cbc3df691439d0195f420d94f8bd313353c2d181a"
    sha256 ventura:       "b28138ebb85c9f03919359b1a41f7f74cf0c74bf3693e838d06241ded5e32f92"
    sha256 arm64_linux:   "50507b3dbed7d6f7c155e2260e0a1c102b8f1a56f8d8a4469d8b6689ca2e28a9"
    sha256 x86_64_linux:  "54499bc5818657bb24d86df3388ed9ea7569925f2aaf573f03909a0082e6b678"
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
