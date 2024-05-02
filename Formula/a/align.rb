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

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "c9faae10da1b1c4bcec6d0c36e63b5dc9320c1bf7751c771b11da859a56a1146"
  end

  conflicts_with "speech-tools", because: "both install `align` binaries"

  def install
    system "make", "install", "BINDIR=#{bin}"
  end

  test do
    assert_equal " 1  1\n12 12\n", pipe_output(bin/"align", "1 1\n12 12\n")
  end
end
