class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.ru/"
  url "http://www.goredo.cypherpunks.ru/download/goredo-1.13.0.tar.zst"
  version "1.13.0"
  sha256 "932e3ac86eabbf2afab69cd0aa6b137363e07329d85aaab706f669fbd99bc517"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.cypherpunks.ru/Install.html"
    regex(/href=.*?goredo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3143cd64a56f93c4e533f11bfc714764e756de8259573f2744a77d3c0d98f0c6"
    sha256 cellar: :any_skip_relocation, big_sur:       "6d63a4c70f75f5181e077c27f3b02b8f83d718c78fee5fff9338bad0f53905de"
    sha256 cellar: :any_skip_relocation, catalina:      "6d63a4c70f75f5181e077c27f3b02b8f83d718c78fee5fff9338bad0f53905de"
    sha256 cellar: :any_skip_relocation, mojave:        "6d63a4c70f75f5181e077c27f3b02b8f83d718c78fee5fff9338bad0f53905de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70e81407e6aac5aa36e16f5e99c275018ab1383c3833da8c92429f1f3fe337aa"
  end

  depends_on "go" => :build
  depends_on "zstd" => :build

  def install
    goredo_prefix = "goredo-#{version}"
    system "tar", "--use-compress-program", "unzstd", "-xvf", "#{goredo_prefix}.tar.zst"
    cd "#{goredo_prefix}/src" do
      system "go", "build", *std_go_args, "-mod=vendor"
    end
    cd bin do
      system "./goredo", "-symlinks"
    end
  end

  test do
    (testpath/"gore.do").write <<~EOS
      echo YOU ARE LIKELY TO BE EATEN BY A GRUE >&2
    EOS
    assert_equal "YOU ARE LIKELY TO BE EATEN BY A GRUE\n", shell_output("#{bin}/redo -no-progress gore 2>&1")
  end
end
