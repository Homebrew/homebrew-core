class Gopeed < Formula
  desc "Modern download manager that supports all platform"
  homepage "https://gopeed.com"
  url "https://github.com/GopeedLab/gopeed/archive/refs/tags/v1.6.7.tar.gz"
  sha256 "b900223ea7696599ff135d78d3111385a46531dcd4b4bd2202d8b207ab21fb71"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8dd354ee6d9664166287794ff2d5fed8cb3da04d421dff15f8f323450b8cf0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f5f20d94851a99e8fe70d8d2ab0786c66e3aeecd33c5a87bfd8c9abc6f5d55e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ddce3a9d297386bb77ef856d8686940b1b4675774209c4b4af6137a8e26a078c"
    sha256 cellar: :any_skip_relocation, sonoma:        "371643181fdc1c00b205ae0f3066c838a197edf4d483291c375a73b0b1019c9c"
    sha256 cellar: :any_skip_relocation, ventura:       "7810935cfa9bfca31e5bca749921ac1c90524cab6e46eb0724138d2b983cb526"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "283be558829d1284d23d7f45aaf9ed7a9150dd30798a056599ec7dfe30d01afc"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gopeed"
  end

  test do
    output = shell_output("#{bin}/gopeed https://example.com/")
    assert_match "saving path: #{testpath}", output
    assert_match "Example Domain", (testpath/"example.com").read
  end
end
