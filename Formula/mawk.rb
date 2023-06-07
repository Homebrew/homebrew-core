class Mawk < Formula
  desc "Interpreter for the AWK Programming Language"
  homepage "https://invisible-island.net/mawk/"
  url "https://invisible-mirror.net/archives/mawk/mawk-1.3.4-20230525.tgz"
  sha256 "5639d14bb9124373b3d7f957d2b925ad8ad9656d46212c3f23dbca810cc9269f"
  license "GPL-2.0-only"

  livecheck do
    url "https://invisible-mirror.net/archives/mawk/?C=M&O=D"
    regex(/href=.*?mawk[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9bcd6ac780b2d22e5e0e6143f4585c455cf856e6c5ef3cc910bedc88ffe55b18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64d3c00eccdc2bc4bb8905d29a1b081d395ea6ca7e5799627a755ffba491e8e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27ec6fa40a3fb7b0d1237cbe0049fec04125ed6235499571b28dee4524dcd1ba"
    sha256 cellar: :any_skip_relocation, ventura:        "ad95f91563cc5cc382d5a226b17ca1b55b0c26a0f1e680848b792f4dd3e3c6ef"
    sha256 cellar: :any_skip_relocation, monterey:       "870caa250d802c20e38bf98dde2553ef065fd6cc680f51967ddf2b368e9b360c"
    sha256 cellar: :any_skip_relocation, big_sur:        "43a05312b379e78d3d9698207bee9fe0f3a4dd1e5f76c4f723417466282c1538"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ed0aeff91f02660f72acd42dd86f2bb8b272de8d6eebfe2de9b3b7d1e25706e"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-silent-rules",
                          "--with-readline=/usr/lib",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    mawk_expr = '/^mawk / {printf("%s-%s", $2, $3)}'
    ver_out = pipe_output("#{bin}/mawk '#{mawk_expr}'", shell_output("#{bin}/mawk -W version 2>&1"))
    assert_equal version.to_s, ver_out
  end
end
