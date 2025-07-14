class NetTools < Formula
  desc "Linux networking base tools"
  homepage "https://sourceforge.net/projects/net-tools/"
  url "https://downloads.sourceforge.net/project/net-tools/net-tools-2.10.tar.xz"
  sha256 "b262435a5241e89bfa51c3cabd5133753952f7a7b7b93f32e08cb9d96f580d69"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_linux:  "a7d523b6843e87fd1b0791952b634c66f5918b78b97e4b851d9d2b3a413e9886"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "eecef80de080f3957e605ff06292e6bffc51f34385307f70896b64d1dd2c823b"
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
