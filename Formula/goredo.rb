class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.ru/"
  url "http://www.goredo.cypherpunks.ru/download/goredo-1.8.0.tar.zst"
  version "1.8.0"
  sha256 "dd8f2c4121b318f655132d142e5e70dbf25a689514b461be5605a7c594693e98"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.cypherpunks.ru/Install.html"
    regex(/href=.*?goredo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9d50fdd15a673d6ca108025518aea07177d4820aed0e0a5f4300a86d84447c71"
    sha256 cellar: :any_skip_relocation, big_sur:       "0fcc3fc1c0af0ea05c96284f6db82379dd843689e75bcded1fc8527b49da049d"
    sha256 cellar: :any_skip_relocation, catalina:      "9e03c6cb942991c25a1ca78e6a09dafc795bd19a65a498e14541a3116b709eab"
    sha256 cellar: :any_skip_relocation, mojave:        "d953588f9a8511c9f6eac5c6b9f9c6e51bb8776123d5e7a00eee39dd9e77c9e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92b6af80813a618d528b4ac00657903505eaaa497459382cd96e83feec64e66e"
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
