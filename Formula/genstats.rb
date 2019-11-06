class Genstats < Formula
  desc "Generate statistics about stdin or textfiles"
  homepage "https://www.vanheusden.com/genstats/"
  url "https://www.vanheusden.com/genstats/genstats-1.2.tgz"
  sha256 "f0fb9f29750cdaa85dba648709110c0bc80988dd6a98dd18a53169473aaa6ad3"

  bottle do
    cellar :any_skip_relocation
    sha256 "8201a8f52e58a092d639023f9232079d7f88f5f5d221947b15c867417537274b" => :catalina
    sha256 "821568c68faf33aa9045ccdcc6975d0f24f4faef8fc747275c5d8f8320d9ad55" => :mojave
    sha256 "7bea82f0ca1047f295bfd0f6ca348f0c07cd33b165bb5a9042c77f9cdc97907f" => :high_sierra
    sha256 "051dbb7c4f653b615b606d1fce15df9336a086e38428fcfdb2aee9f0057d8990" => :sierra
    sha256 "44502f7a2dfcb1355336db69267d6363d6e8b8767b47628b0d3099743513ed5f" => :el_capitan
    sha256 "91737ec825ed346716fddcedc4e075b195f214dfb22586a33d46f7ec5ea3a17e" => :yosemite
    sha256 "d46142a806e13029120bfb1a038805b07dc88b191aed1cd41340f5f868168f92" => :mavericks
  end

  def install
    # Tried to make this a patch.  Applying the patch hunk would
    # fail, even though I used "git diff | pbcopy". Tried messing
    # with whitespace, # lines, etc.  Ugh.
    inreplace "br.cpp", /if \(_XOPEN_VERSION >= 600\)/,
                        "if (_XOPEN_VERSION >= 600) && !__APPLE__"

    system "make"
    bin.install "genstats"
    man.install "genstats.1"
  end

  test do
    output = shell_output("#{bin}/genstats -h", 1)
    assert_match "folkert@vanheusden.com", output
  end
end
