class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.ru/"
  url "http://www.goredo.cypherpunks.ru/download/goredo-1.11.0.tar.zst"
  version "1.11.0"
  sha256 "c3102d39c9b733a251efabf1788d54df9d2e7679b5366ffb9f4bbad24d6c4166"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.cypherpunks.ru/Install.html"
    regex(/href=.*?goredo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f5591f31fa6cf9fd036cacecf703735ccd514227bf5a90e9a18cf89bcef0675f"
    sha256 cellar: :any_skip_relocation, big_sur:       "d1ba799b062e11148e0c15023fd52477d7f98cb0c68b440536e2c289f18f5434"
    sha256 cellar: :any_skip_relocation, catalina:      "d1ba799b062e11148e0c15023fd52477d7f98cb0c68b440536e2c289f18f5434"
    sha256 cellar: :any_skip_relocation, mojave:        "d1ba799b062e11148e0c15023fd52477d7f98cb0c68b440536e2c289f18f5434"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1822dc36d9fb266b281c3ac9630855b3a54dbd22119e22d586808683d2674eb7"
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
