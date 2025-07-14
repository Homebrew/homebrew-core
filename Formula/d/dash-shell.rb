class DashShell < Formula
  desc "POSIX-compliant descendant of NetBSD's ash (the Almquist SHell)"
  homepage "http://gondor.apana.org.au/~herbert/dash/"
  url "http://gondor.apana.org.au/~herbert/dash/files/dash-0.5.12.tar.gz"
  sha256 "6a474ac46e8b0b32916c4c60df694c82058d3297d8b385b74508030ca4a8f28a"
  license "BSD-3-Clause"
  head "https://git.kernel.org/pub/scm/utils/dash/dash.git", branch: "master"

  livecheck do
    url "http://gondor.apana.org.au/~herbert/dash/files/"
    regex(/href=.*?dash[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ed8b5c3067b48a7ec6f8a11dbc3b76a48db45212fe136bf8ee921db004cdc6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50cacbfd6242b8a779665b21ddaa9f4e97c08eff5e0707d095d89dee599ba676"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "348d2957ace43b03c57eddd6c2697befd3a2afef45e2d9d91deb7833b3930edb"
    sha256 cellar: :any_skip_relocation, sonoma:        "1c383f58c7cc463ca50c897dcedc4eafeea3c819f007b8363e341dd31764e25b"
    sha256 cellar: :any_skip_relocation, ventura:       "d89ba70e81c7aa2df99f5188ef301aecd5dfa724bc50ab2dd5c3adc610cebcff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04cb4135adf52aecc6371de7338eaf3e359ebdf102c4bb0ee4f760cd42bc47fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc253f40ad6f25e27fdb7ea2851c3382336b2ce4b62141bfa223e7aed32355b5"
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
