class NoMoreSecrets < Formula
  desc "Recreates the SETEC ASTRONOMY effect from 'Sneakers'"
  homepage "https://github.com/bartobri/no-more-secrets"
  url "https://github.com/bartobri/no-more-secrets/archive/v0.2.1.tar.gz"
  sha256 "b5e899a318c64f2f18c85fce6e5a434d604b80f0fd41a3a5a3338f195b8a41c4"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b4c4af8d3475fc8288541878ef4261317155fd898a45add6a99ed7f704f873e" => :el_capitan
    sha256 "9043f555a3586cb6f9e6d14cb2ee6af8e10510e6946f80bb6d8799ca914492d2" => :yosemite
    sha256 "e6969faff5484a728a6b339b4c6448e4b801313253c4eea874d8f705f8f3b6fe" => :mavericks
  end

  def install
    system "make", "all"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    assert_equal "nms version #{version}", shell_output("#{bin}/nms -v").chomp
  end
end
