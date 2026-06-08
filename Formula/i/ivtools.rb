class Ivtools < Formula
  desc "X11 vector graphic servers"
  homepage "https://github.com/vectaport/ivtools"
  url "https://github.com/vectaport/ivtools/archive/refs/tags/ivtools-2.1.1.tar.gz"
  sha256 "4fa680b9d0fd2af610e9012258e150249d9a8abbc3b1f65eb17d01c959142cfc"
  license "MIT"
  revision 5

  bottle do
    sha256 arm64_tahoe:   "845518c5d1aee4a85f8037ef2de2c74dc4e18937782b9ee204aee7a681ee243f"
    sha256 arm64_sequoia: "2855848a765bb2ad5cca364493fc6c3b4a6faa9b820a4c407bdabc60a2efa04c"
    sha256 arm64_sonoma:  "35e474153279f2a430b586145bd814571ca4db62af85a41a30cdb8eef92a7b6a"
    sha256 sonoma:        "d5abd1bf80062f3e1f3aaf6b6e1af94db3638111e10f1abf7b884a933c018238"
    sha256 arm64_linux:   "235e2672e79201a57089195d288a40f282b55fba3d101d56876cb4774db62588"
    sha256 x86_64_linux:  "94b206cbf2f85a2530aa1f38ba9a35eee52383cc45644cd5cf7f57318d8c9f75"
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
