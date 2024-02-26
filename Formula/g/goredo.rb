class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.ru/"
  url "http://www.goredo.cypherpunks.ru/download/goredo-2.6.1.tar.zst"
  sha256 "4878761886d1628fd0bedf1a21f5e822fbe79de5878425600b2ca8edc230af98"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.cypherpunks.ru/Install.html"
    regex(/href=.*?goredo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "03b821165098e83cc4f81cef609bdb2f0863f078f91836f69312f2aee7ee8f27"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "393d52d4ccdfa4abb5aa2350d8d13f52dbb77452716e0a3c8663b8167120d22b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "368b8b5eabf1bec8c6f19052264f7f057b3b1af923c142004cf08c88bceb9199"
    sha256 cellar: :any_skip_relocation, sonoma:         "a82a7a967a1128cca409bddd8176be5a1a671ce71f7e059efc9e49427d67fedc"
    sha256 cellar: :any_skip_relocation, ventura:        "2045cdf300e5051b69619719000fecf552b9f19d6874aa207077938866a8e8e2"
    sha256 cellar: :any_skip_relocation, monterey:       "a33934a05bbe0f8a5b39835ab5325223d24f47f7f340066548a0945a6b633657"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "580fd886613cc59623e34c4f509c0b2db127845248cd02e25fd065287917e944"
  end

  depends_on "go" => :build

  def install
    cd "src" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "-mod=vendor"
    end

    ENV.prepend_path "PATH", bin
    cd bin do
      system "goredo", "-symlinks"
    end
  end

  test do
    (testpath/"gore.do").write <<~EOS
      echo YOU ARE LIKELY TO BE EATEN BY A GRUE >&2
    EOS
    assert_match "YOU ARE LIKELY TO BE EATEN BY A GRUE\n", shell_output("#{bin}/redo -no-progress gore 2>&1")

    assert_match version.to_s, shell_output("#{bin}/goredo -version")
  end
end
