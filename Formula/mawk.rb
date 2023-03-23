class Mawk < Formula
  desc "Interpreter for the AWK Programming Language"
  homepage "https://invisible-island.net/mawk/"
  url "https://invisible-mirror.net/archives/mawk/mawk-1.3.4-20230322.tgz"
  sha256 "cafaa642c6d738484dedcb24e8433bf57ff1f7ee958cfa547603e433135d9d89"
  license "GPL-2.0-only"

  livecheck do
    url "https://invisible-mirror.net/archives/mawk/?C=M&O=D"
    regex(/href=.*?mawk[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9f4b99fa6aac1ad10d33664a21166b4dbb891b364bf8733564b446064719180"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35dfd1bf6c13583f52a4eb530e070ee1a6f580173352711fa5240ac7f20d1195"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19341d6e0bb54ba93eb4e1b9df2fdd248c0c84bc49289668f6675b3f3efb86d5"
    sha256 cellar: :any_skip_relocation, ventura:        "b294b3a40fe98791a70ad103f08f5324b62890d35510af4cb0e67f311b94032f"
    sha256 cellar: :any_skip_relocation, monterey:       "48710755a0d4afe0f38871a07e715f5f75a8b6a13ac53216b8b2e47c8b3a5987"
    sha256 cellar: :any_skip_relocation, big_sur:        "0540238a8c4dc9829d1a83a39e32d374ca7d5499083761d0f582699520ee4a8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c773761adb1755191d2a912ee394c56b644c198c4c43c0a1623bda63690d40c3"
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
