class DashShell < Formula
  desc "POSIX-compliant descendant of NetBSD's ash (the Almquist SHell)"
  homepage "http://gondor.apana.org.au/~herbert/dash/"
  url "https://cdn.netbsd.org/pub/pkgsrc/distfiles/dash-0.5.13.5.tar.gz"
  mirror "http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.13.5.tar.gz"
  sha256 "40090101a2a491f13e901d3d48e90414f26634628b9bfff35ff540363c227a7d"
  license "BSD-3-Clause"
  head "https://git.kernel.org/pub/scm/utils/dash/dash.git", branch: "master"

  livecheck do
    url "http://gondor.apana.org.au/~herbert/dash/files/"
    regex(/href=.*?dash[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b16ec78b4230ba8826c6991666acacb8489621c4faad001c775526f3709899e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e104457d0d188129596ee04e4f88ab6039baf9a03e183820caf0aa333d581d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0d1db055b541d6fe8bb74ea606c3d231e73d2ab8585fd69f1698d111c1db8a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "67a77615d9fc06d64aaf8bc8674c0064db8e2eb86b11387340115099e9d60291"
    sha256 cellar: :any,                 arm64_linux:   "75c41698c960677b3f093033378b3360cdf63298929b8c9e8faf2f3281a1f836"
    sha256 cellar: :any,                 x86_64_linux:  "48677dd2cc480fe1f2dc977a7c8c7284cb4a35e1ac2c005f81d22426a9396b54"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "libedit"

  def install
    ENV["ac_cv_func_stat64"] = "no" if OS.mac? && Hardware::CPU.arm?
    system "./autogen.sh" if build.head?
    system "./configure", "--with-libedit", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"dash", "-c", "echo Hello!"
  end
end
