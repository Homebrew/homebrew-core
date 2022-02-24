class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.ru/"
  url "http://www.goredo.cypherpunks.ru/download/goredo-1.23.0.tar.zst"
  sha256 "9ff516c79ee3db0a452362819bc3df60e237c7540d62db9b4af2c6dbe775546b"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.cypherpunks.ru/Install.html"
    regex(/href=.*?goredo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6375d7ba811d5204854dd322cc1b4b512cbc38e593429c4637e703515e2a660e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6375d7ba811d5204854dd322cc1b4b512cbc38e593429c4637e703515e2a660e"
    sha256 cellar: :any_skip_relocation, monterey:       "6f2feccb1321deaf482e8584b1ab33b68a0ed6865a545c78ae403df5c04a01b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f2feccb1321deaf482e8584b1ab33b68a0ed6865a545c78ae403df5c04a01b3"
    sha256 cellar: :any_skip_relocation, catalina:       "6f2feccb1321deaf482e8584b1ab33b68a0ed6865a545c78ae403df5c04a01b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "415d31ceb8650b834a6696527e29789ed06952e6a24c36dc376d9c5b722650cf"
  end

  depends_on "go" => :build

  def install
    cd "src" do
      system "go", "build", *std_go_args, "-mod=vendor"
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
    assert_equal "YOU ARE LIKELY TO BE EATEN BY A GRUE\n", shell_output("#{bin}/redo -no-progress gore 2>&1")
  end
end
