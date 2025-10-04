class DashShell < Formula
  desc "POSIX-compliant descendant of NetBSD's ash (the Almquist SHell)"
  homepage "http://gondor.apana.org.au/~herbert/dash/"
  url "http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.13.tar.gz"
  sha256 "fd8da121e306b27f59330613417b182b8844f11e269531cc4720bf523e3e06d7"
  license "BSD-3-Clause"
  head "https://git.kernel.org/pub/scm/utils/dash/dash.git", branch: "master"

  livecheck do
    url "http://gondor.apana.org.au/~herbert/dash/files/"
    regex(/href=.*?dash[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d23db2f3b32191917ebb7597c48fffa49c5dc7a5287c75ddec9e0c7dc987792"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a1b763978216798991a3aac96d31de930175918710b7852a2bc6e6f6f24df0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c477b0796465f13b700beffa460072270cf7190665dff78109e39fe1bc2ccd39"
    sha256 cellar: :any_skip_relocation, sonoma:        "75d2eabfdab1bb8a70096359d64d30e7ab75a9a7cb95271ba9979a9c6798e491"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea789f76d211c1d095346b3d8a0a1869a69b68500f95db8e448c387e2fd12780"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17f763b9e05df4869e14f8a3bab77fcc928beda8ff273f986a2aedb83ce06111"
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
