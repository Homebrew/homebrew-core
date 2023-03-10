class Neatvi < Formula
  desc "Clone of ex/vi for editing bidirectional utf-8 text"
  homepage "https://repo.or.cz/neatvi.git"
  url "https://repo.or.cz/neatvi.git",
      tag:      "11",
      revision: "c4d323dc210ae5dcd828b0222b3748c3e1de2abc"
  license "ISC"
  head "https://repo.or.cz/neatvi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21431d7cfd1566d44ffac423f8780af05373d865e88c7de59658287d89881ebc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1885311d215041a7fcbe43af2aad4d243a72db131f59bf16d5e8c38833c420f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d02348c64815db38c3e52784dcd444bf926a39f5ec45770e417938760a9574b"
    sha256 cellar: :any_skip_relocation, ventura:        "c57570242789947c6cf170de16b051ea318442359c8b88bec70f6c87673adccc"
    sha256 cellar: :any_skip_relocation, monterey:       "51b6ff945536b24119c2bdea08b0b383dedf07a30c8bb383ff5325ee50a47f49"
    sha256 cellar: :any_skip_relocation, big_sur:        "d91af1b2e27813770c80a8011828654f67835f90bdcc371b8f92ccbef65d9ec5"
    sha256 cellar: :any_skip_relocation, catalina:       "95e2903443c4855bf5930ff40c082914747bd867bd313d016d17d684b4ec630d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c0afe01b93c3bfd7e437fa8ceb661fee81c81a4c0c0d198bf21767f4a410ee8"
  end

  def install
    system "make"
    bin.install "vi" => "neatvi"
  end

  test do
    pipe_output("#{bin}/neatvi", ":q\n")
  end
end
