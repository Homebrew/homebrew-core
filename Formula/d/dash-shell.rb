class DashShell < Formula
  desc "POSIX-compliant descendant of NetBSD's ash (the Almquist SHell)"
  homepage "http://gondor.apana.org.au/~herbert/dash/"
  url "http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.13.1.tar.gz"
  sha256 "d9271bce09c127d9866e25c011582ddc75ab988958a04bc4d8553a3b8f30e370"
  license "BSD-3-Clause"
  head "https://git.kernel.org/pub/scm/utils/dash/dash.git", branch: "master"

  livecheck do
    url "http://gondor.apana.org.au/~herbert/dash/files/"
    regex(/href=.*?dash[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9d493aa8aa6589e372227e67dbb93708fdcf992d9064e75009f3917ab7b3e0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6dfc2b72fdef57ba537e5fcf2e83e0d66a33f60043ec3f47a21a58249da4971d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b51e19b98c71255053e593f7b7879699e84fd38672d68dc6093de6f3061b29fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "4eaea3dee21db06c3b043fd6db4a100ccf760a06a0c96477b74c514a4b4167a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f50cf54fb40c64c35822a9190e5336ae9c3b59d4923c18ebc82ea68cb4294a0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25031c85030fc02517ad9872f31804b6b4d03af43b4672c2a901c01dcc7cdc84"
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
