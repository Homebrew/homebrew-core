class NoMoreSecrets < Formula
  desc "Recreates the SETEC ASTRONOMY effect from 'Sneakers'"
  homepage "https://github.com/bartobri/no-more-secrets"
  url "https://github.com/bartobri/no-more-secrets/archive/v0.2.1.tar.gz"
  sha256 "b5e899a318c64f2f18c85fce6e5a434d604b80f0fd41a3a5a3338f195b8a41c4"

  bottle do
    cellar :any_skip_relocation
    sha256 "5fba9c507bf8b91747a85e849d5954b3292c57371184553670a986d81ee1abd2" => :sierra
    sha256 "731a98492d79ba911f862f6e0749cec40983e23ccb22ef55fe020d07760cdee9" => :el_capitan
    sha256 "15baf1b90d42f6215780f6b51b2dd51a0b41423c6fa68725124c66b94bf0d9cf" => :yosemite
    sha256 "f3eac856adca1ff5a5573e32902052e3a43629cb2bd09bec1945a663b5392a63" => :mavericks
  end

  def install
    system "make", "all"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    assert_equal "nms version #{version}", shell_output("#{bin}/nms -v").chomp
  end
end
