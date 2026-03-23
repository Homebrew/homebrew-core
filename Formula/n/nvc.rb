class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://www.nickg.me.uk/nvc/"
  url "https://github.com/nickg/nvc/releases/download/r1.19.3/nvc-1.19.3.tar.gz"
  sha256 "ce2c2d48e097928170489c4193194a51fb97ae9b5d8828de88b279ae02672021"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "2cdbb1f94e69bc27c5f24f2930cd76ea99852a592ebc2a3f6c1d22026df2d136"
    sha256 arm64_sequoia: "b0bef2ccd32347faefe149940dee2ce53b5bde4a47c604718d1f88c66e5600e5"
    sha256 arm64_sonoma:  "a76845ff90a3f4d7cabc3b31904ff13b532748440614eefdd7775a9c313ec9ac"
    sha256 sonoma:        "233a646700ec2c69d01cad557b91973552d702eb49f24a69139dad7616fa74e7"
    sha256 arm64_linux:   "63acb3ca9c7c8df8d326abd1f24f91cd71372e94d45f3d6eddafd6b01befb3aa"
    sha256 x86_64_linux:  "cc47f5559b9a9753da327230e580b872303c99ef46f5bda1982ccfdd316ad885"
  end

  head do
    url "https://github.com/nickg/nvc.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "check" => :build
  depends_on "pkgconf" => :build
  depends_on "llvm"
  depends_on "zstd"

  uses_from_macos "flex" => :build
  uses_from_macos "libffi"

  on_linux do
    depends_on "elfutils"
    depends_on "zlib-ng-compat"
  end

  def install
    system "./autogen.sh" if build.head?

    # Avoid hardcoding path to the `ld` shim.
    ENV["ac_cv_path_linker_path"] = "ld" if OS.linux?

    # In-tree builds are not supported.
    mkdir "build" do
      system "../configure", "--with-llvm=#{Formula["llvm"].opt_bin}/llvm-config",
                             "--disable-silent-rules",
                             *std_configure_args
      system "make", "V=1"
      system "make", "V=1", "install"
    end

    (pkgshare/"examples").install "test/regress/wait1.vhd"
  end

  test do
    resource "homebrew-test" do
      url "https://raw.githubusercontent.com/suoto/vim-hdl-examples/fcb93c287c8e4af7cc30dc3e5758b12ee4f7ed9b/basic_library/very_common_pkg.vhd"
      sha256 "42560455663d9c42aaa077ca635e2fdc83fda33b7d1ff813da6faa790a7af41a"
    end

    testpath.install resource("homebrew-test")
    system bin/"nvc", "-a", testpath/"very_common_pkg.vhd"
    system bin/"nvc", "-a", pkgshare/"examples/wait1.vhd", "-e", "wait1", "-r"
  end
end
