class NetTools < Formula
  desc "Linux networking base tools"
  homepage "https://sourceforge.net/projects/net-tools"
  url "https://downloads.sourceforge.net/project/net-tools/net-tools-2.10.tar.xz"
  sha256 "b262435a5241e89bfa51c3cabd5133753952f7a7b7b93f32e08cb9d96f580d69"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e08cb177a10583b6af76c29fa3c49c930d057aaa759946b72a579205d3fc093f"
  end

  depends_on "libdnet"
  depends_on :linux

  def install
    # Support non-interactive configuration
    inreplace "configure.sh", "IFS='@' read ans || exit 1", ""

    system "make", "config"
    system "make"
    system "make", "DESTDIR=#{prefix}", "install"
  end

  test do
    assert_match "Kernel Interface table", shell_output("#{bin}/netstat -i")
  end
end
