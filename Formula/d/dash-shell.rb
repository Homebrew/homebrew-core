class DashShell < Formula
  desc "POSIX-compliant descendant of NetBSD's ash (the Almquist SHell)"
  homepage "http://gondor.apana.org.au/~herbert/dash/"
  url "https://cdn.netbsd.org/pub/pkgsrc/distfiles/dash-0.5.13.2.tar.gz"
  mirror "http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.13.2.tar.gz"
  sha256 "e7136826b1eed6ce3193e8affa2f70b1b2b9168dd91ffa7ddb4f46e9e62054fe"
  license "BSD-3-Clause"
  head "https://git.kernel.org/pub/scm/utils/dash/dash.git", branch: "master"

  livecheck do
    url "http://gondor.apana.org.au/~herbert/dash/files/"
    regex(/href=.*?dash[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7796c200354aacda53355c94825f6ad57db2b06918809bd686c18d718b76facb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c9a9310a9d0d7e25d3da03b9ff6741ef1665d408ee1c1c64251a0bd6e48d997"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b521040d0d3b5cd9f2106dafad60a16ca0f62a9e497eb9798d4a5368c657cb6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f7595fb77974b4eb23f06f5ba687d9b812c2b98a77b3a83a4224e576033d859"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b9a42405cd16446d7ed55e26d2ded21080e2929a8a66e1b905a2f98c3d26867"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8217368265784d89ee03c02e3b7226da9f7ddc24be96c03a8d8ba51813721351"
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
