class MacRobber < Formula
  desc "Digital investigation tool"
  homepage "https://www.sleuthkit.org/mac-robber/"
  url "https://downloads.sourceforge.net/project/mac-robber/mac-robber/1.02/mac-robber-1.02.tar.gz"
  sha256 "5895d332ec8d87e15f21441c61545b7f68830a2ee2c967d381773bd08504806d"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "94a1d9c4a38418ea7b3faa63700f5e27ed8ae8daf213ebeba74ea1bb6438d711"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "554220e0bdcd9ca88279f3dc6070bf07158ba85468f52bbea7ac0f385075203a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "39769b8a01d0d7b97d7b3ca95c5f17f79bba4fb431fc3dcc2a3c0f616c2c369f"
    sha256 cellar: :any,                 arm64_linux:       "24baadae3e3ad583db3734a3985a8849f7eaac93dce06ac7ebc1bd32914bc541"
    sha256 cellar: :any,                 x86_64_linux:      "d304cc5058841e57e8f3e32805a971e05d81dc55118a30a574e080037f730584"
  end

  deny_network_access!

  def install
    system "make", "CC=#{ENV.cc}", "GCC_OPT=#{ENV.cflags}"
    bin.install "mac-robber"
  end

  test do
    (testpath/"data").mkpath
    (testpath/"data/hello.txt").write "hello"
    chmod 0644, testpath/"data/hello.txt"
    (testpath/"data/link").make_symlink "hello.txt"

    output = shell_output("#{bin}/mac-robber data")
    assert_match "MD5|name|inode|mode_as_string|UID|GID|size|atime|mtime|ctime|crtime", output
    assert_match %r{^0\|data/hello\.txt\|0\|-rw-r--r--\|\d+\|\d+\|5\|}, output
    assert_match %r{^0\|data/link\|0\|l\S+ -> hello\.txt\|}, output

    assert_match "invalid directory: missing/", shell_output("#{bin}/mac-robber missing", 1)
  end
end
