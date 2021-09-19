class Goredo < Formula
  desc "Go implementation of djb's redo, a Makefile replacement that sucks less"
  homepage "http://www.goredo.cypherpunks.ru/"
  url "http://www.goredo.cypherpunks.ru/download/goredo-1.14.0.tar.zst"
  version "1.14.0"
  sha256 "17608c98b39e0030043b1862edb0ae7c162da3743ddf87330db0301a4fd61bf5"
  license "GPL-3.0-only"

  livecheck do
    url "http://www.goredo.cypherpunks.ru/Install.html"
    regex(/href=.*?goredo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7eb94ca32e64e46ca78151bee85191067c45e381010aad71ab6901cf7663134e"
    sha256 cellar: :any_skip_relocation, big_sur:       "ffaefb3d11c56ce4b14cfcc0a5cea844a637f03a501b7ba4b0e1cc59239af982"
    sha256 cellar: :any_skip_relocation, catalina:      "ffaefb3d11c56ce4b14cfcc0a5cea844a637f03a501b7ba4b0e1cc59239af982"
    sha256 cellar: :any_skip_relocation, mojave:        "ffaefb3d11c56ce4b14cfcc0a5cea844a637f03a501b7ba4b0e1cc59239af982"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4635d3c18018d3cf10ae4e013c135974b079440a4cc5f73b3df17d14c95794d8"
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
