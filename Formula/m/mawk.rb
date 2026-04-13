class Mawk < Formula
  desc "Interpreter for the AWK Programming Language"
  homepage "https://invisible-island.net/mawk/"
  url "https://invisible-mirror.net/archives/mawk/mawk-1.3.4-20260302.tgz"
  sha256 "e2c08a77d0a84a01f9be454d1ca3872d4f103f9ada683d075198b0c6e965633d"
  license "GPL-2.0-only"

  livecheck do
    url "https://invisible-mirror.net/archives/mawk/?C=M&O=D"
    regex(/href=.*?mawk[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf4ed75710af2d4e5d6a50d1563303510e789498875b7724367805f6db524361"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "803a6960151403d036b163aeb09c13248f78d63314ecc97816ad03188c39334a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fa506e3280172fc8bb7bc33ce3eebdf8eabc8c9a952f3132340e0b8c3bdebe2"
    sha256 cellar: :any_skip_relocation, sonoma:        "788bb3c387eb0df4dfbf2f1a960198fffe2eb8016516fd38cf59b6eda544cb1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76e535fca1e876b60ab619aada6e439830832e267846a8a64482e6c01b1bd27c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb785fa963052b93f5b6a5e730baee05d3ce373b9898db1f547014208a6301fa"
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
