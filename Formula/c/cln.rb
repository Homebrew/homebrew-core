class Cln < Formula
  desc "Class Library for Numbers"
  homepage "https://www.ginac.de/CLN/"
  url "https://www.ginac.de/CLN/cln-1.3.7.tar.bz2"
  sha256 "7c7ed8474958337e4df5bb57ea5176ad0365004cbb98b621765bc4606a10d86b"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?cln[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "eecbd9b437a3d34fd0a2b247fd7a3370109b5a764f9bf3fdaa99ad40b1fbcc7f"
    sha256 cellar: :any, arm64_tahoe:       "82df63ebc446543a6c05219ad65d2de6e9e7d90a9717022d13b9e6858b9acf29"
    sha256 cellar: :any, arm64_sequoia:     "3bb3c98eb2263f2eb1ad30f5dc8059b4b668951f6412dd2c3d4ae66ad4c2fb62"
    sha256 cellar: :any, arm64_linux:       "c78c81ce4a3ce4249fd7ba0835a982e863a1e5d2c77f5601602fa66c361f8440"
    sha256 cellar: :any, x86_64_linux:      "0db1112f7433248b6edeebe7055512bac1e2e4977aafb9dc70e7570fe4190e46"
  end

  head do
    url "git://www.ginac.de/cln.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "wget" => :build

    on_system :linux, macos: :ventura_or_newer do
      depends_on "texinfo" => :build
    end
  end

  depends_on "gmp"

  def install
    # Apple clang 21 miscompiles the negative-index-via-unsigned idiom in `cl_DS.h`, breaking `make check`
    ENV.append_to_cflags "-fwrapv-pointer" if DevelopmentTools.clang_build_version >= 2100

    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    assert_match "3.14159", shell_output("#{bin}/pi 6")
  end
end
