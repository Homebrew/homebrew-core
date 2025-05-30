class Align < Formula
  desc "Text column alignment filter"
  homepage "https://kinzler.com/me/align/"
  url "https://kinzler.com/me/align/align-1.7.5.tgz"
  sha256 "cc692fb9dee0cc288757e708fc1a3b6b56ca1210ca181053a371cb11746969dd"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?align[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "59752d9b714819dca9ca9a6bd4cf70a9a78645aad65a2b5d031812ee84b52c5c"
  end

  conflicts_with "speech-tools", because: "both install `align` binaries"

  def install
    system "make", "install", "BINDIR=#{bin}"
  end

  test do
    assert_equal " 1  1\n12 12\n", pipe_output(bin/"align", "1 1\n12 12\n", 0)
  end
end
