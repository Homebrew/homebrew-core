class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.ru/"
  url "http://www.goredo.cypherpunks.ru/download/goredo-2.6.2.tar.zst"
  sha256 "5663ed0da911f1b2c0d13e92cc06ede3738639edb48499eb9e53d38e8e435d75"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.cypherpunks.ru/Install.html"
    regex(/href=.*?goredo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "817850b83cc6f39ee4cdf18a155cbf9f647825a3263ae4d988531fe5d2fd8d83"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2158ddd6dff1dfe9189a218476ee898cd8a4572a81255db8ccd180240d20763"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08ebcf9e4213214a4f9ee08be49a0e83cf64bcca2e7f93ec3fb8e7ae6342dcf3"
    sha256 cellar: :any_skip_relocation, sonoma:         "9a60c6e982e2e0444a7837d0d8ee71c5adb90727a326bc922056ac7dbdbbeaeb"
    sha256 cellar: :any_skip_relocation, ventura:        "3441512d3bd3c9ca4e673e8036e3047222a7a4429e30b0a27eed001e5dd55e82"
    sha256 cellar: :any_skip_relocation, monterey:       "9bfd67a34df85bae08ec4661bac3e4ef1663a90d3f6da68b4a5095386fd73b5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57fa594b1d25f261ca19db5daf1f0211c64747d1b57d5758adbf53f0495ba0b6"
  end

  depends_on "go" => :build

  conflicts_with "redo", because: "both install `redo` and `redo-*` binaries"

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
