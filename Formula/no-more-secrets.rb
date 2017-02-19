class NoMoreSecrets < Formula
  desc "Recreates the SETEC ASTRONOMY effect from 'Sneakers'"
  homepage "https://github.com/bartobri/no-more-secrets"
  url "https://github.com/bartobri/no-more-secrets/archive/v0.3.1.tar.gz"
  sha256 "d30d5854f3feac6d680c55f846f1a3b5edc3772d9bbea1c81cc775ccf6ec1443"

  bottle do
    cellar :any_skip_relocation
    sha256 "82d5a97f6eb4ed126fe6e48178256e25cde430a40f96a77a734c63632fc37784" => :sierra
    sha256 "4125b8fa04ca1ec2bdc027149c3dbee68612a107d7dfb1638eb460675c7c4855" => :el_capitan
    sha256 "91c5863393463152867f56791eea0c0c450fd8431711433ac832f68aedf0e4f8" => :yosemite
  end

  def install
    system "make", "all"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    assert_equal "nms version #{version}", shell_output("#{bin}/nms -v").chomp
  end
end
