class Grepcidr < Formula
  desc "Filter IP addresses matching IPv4 CIDR/network specification"
  homepage "http://www.pc-tools.net/unix/grepcidr/"
  url "http://www.pc-tools.net/files/unix/grepcidr-2.0.tar.gz"
  sha256 "61886a377dabf98797145c31f6ba95e6837b6786e70c932324b7d6176d50f7fb"

  bottle do
    cellar :any_skip_relocation
    sha256 "195665f1f4647ec6ee1f43830cd21079413fc8c1df4dce5e869891d402791488" => :mojave
    sha256 "7266be7b9262d50ab08d63529cf9858764573784ab63918010454ec2d76363b6" => :high_sierra
    sha256 "12dfa49026bffb77ed1c4a08e9b60b56859eb183bbf791754d0b1d476ba6d795" => :sierra
    sha256 "31ccf6792cab3c5022530ef4576ea53e6dedd4855b939d11212fea0d7fa294dc" => :el_capitan
    sha256 "d0024b81610b4a698de415aef87958e2a61f74a9f1f2b7acf875f2f3d50ecc05" => :yosemite
    sha256 "c4ed3ba91b4acd41f51850b143ea9826275b221fc8f041098dfe5f5a429a0289" => :mavericks
  end

  def install
    system "make"
    bin.install "grepcidr"
    man1.install "grepcidr.1"
  end

  test do
    (testpath/"access.log").write <<~EOS
      127.0.0.1 duck
      8.8.8.8 duck
      66.249.64.123 goose
      192.168.0.1 duck
    EOS

    output = shell_output("#{bin}/grepcidr 66.249.64.0/19 access.log")
    assert_equal "66.249.64.123 goose", output.strip
  end
end
