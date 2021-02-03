class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.ru/"
  url "http://www.goredo.cypherpunks.ru/download/goredo-1.2.0.tar.zst"
  version "1.2.0"
  sha256 "d0045dbaf60fb731b3db64ab262e600a3d68e487d167a0f19dd614dac6e57cd5"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a0a9bb36dc434f6a73d7c1ddf172d773c1c6719c6e4eb8f2bb971d12386a1b84"
    sha256 cellar: :any_skip_relocation, big_sur:       "b42f2b3a414bb8202c64e05dd3b10436e9e33f3875ed6cc7080ec1f90b11b48c"
    sha256 cellar: :any_skip_relocation, catalina:      "c342bd2a9a27747e0eaae16ce4dda29ca430bd730011a1b0794d0a9734d46afe"
    sha256 cellar: :any_skip_relocation, mojave:        "06a24d2d67342fbfe8fcee8d4b912d678164bd3d7fb7bdd35b700cf46e2687aa"
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
