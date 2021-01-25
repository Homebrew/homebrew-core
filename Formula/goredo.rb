class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.ru/"
  url "http://www.goredo.cypherpunks.ru/download/goredo-1.0.0.tar.zst"
  version "1.0.0"
  sha256 "8d99b8fc1057aef6437be1312112781e00030afdd01da2f0e233b042187a2f01"
  license "GPL-3.0-only"

  bottle do
    cellar :any_skip_relocation
    sha256 "663c62a3318bb14e86ca61e9f70bd23d1c89c7ea0ee8e7f270aec3831893e6a9" => :big_sur
    sha256 "486255d07949c3cc4f49a2962ec7ca593d1f00ee81900ccee4b03a05c9cc8c62" => :arm64_big_sur
    sha256 "9ac536d8704588a968b3a6be3182d7763b39e016bad7d3f9d550e4742a757e42" => :catalina
    sha256 "400a1ed8419de96fc8d331c6fa8be4df016ebccaedecef189131501008109bad" => :mojave
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
