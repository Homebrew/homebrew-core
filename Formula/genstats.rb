class Genstats < Formula
  desc "Generate statistics about stdin or textfiles"
  homepage "https://www.vanheusden.com/genstats/"
  url "https://www.vanheusden.com/genstats/genstats-1.2.tgz"
  sha256 "f0fb9f29750cdaa85dba648709110c0bc80988dd6a98dd18a53169473aaa6ad3"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d60b585ddff616135b75457e8f51cc3d8b1cfc9a03fded05df23fde64a74cddb"
    sha256 cellar: :any_skip_relocation, big_sur:       "0ade68d6af3fe20c73c8e5baf05138c4d7e4f774acda2ed8b2a51aa18bbde0e4"
    sha256 cellar: :any_skip_relocation, catalina:      "8201a8f52e58a092d639023f9232079d7f88f5f5d221947b15c867417537274b"
    sha256 cellar: :any_skip_relocation, mojave:        "821568c68faf33aa9045ccdcc6975d0f24f4faef8fc747275c5d8f8320d9ad55"
    sha256 cellar: :any_skip_relocation, high_sierra:   "7bea82f0ca1047f295bfd0f6ca348f0c07cd33b165bb5a9042c77f9cdc97907f"
    sha256 cellar: :any_skip_relocation, sierra:        "051dbb7c4f653b615b606d1fce15df9336a086e38428fcfdb2aee9f0057d8990"
    sha256 cellar: :any_skip_relocation, el_capitan:    "44502f7a2dfcb1355336db69267d6363d6e8b8767b47628b0d3099743513ed5f"
  end

  disable! date: "2022-07-31", because: "Upstream website has disappeared"

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
