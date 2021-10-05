class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.ru/"
  url "http://www.goredo.cypherpunks.ru/download/goredo-1.15.0.tar.zst"
  sha256 "3aec3a78a7e66e1df9deb73e67876fdddb089b3261fff83a56b43b9a5274b30b"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.cypherpunks.ru/Install.html"
    regex(/href=.*?goredo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c80b073b314bd3d83d9c8aae71ed31f76d5e5275cd2d17cf4dab70ad66a8a41e"
    sha256 cellar: :any_skip_relocation, big_sur:       "88f29b1720596ac180b259f87513bf8a362033e168aa83c95c69f2f57ad545fe"
    sha256 cellar: :any_skip_relocation, catalina:      "88f29b1720596ac180b259f87513bf8a362033e168aa83c95c69f2f57ad545fe"
    sha256 cellar: :any_skip_relocation, mojave:        "88f29b1720596ac180b259f87513bf8a362033e168aa83c95c69f2f57ad545fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a851c3e19bc7a63be53a57ae603e8f1b42ffac8b82f56e8fdc08986b2bbbf9da"
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
