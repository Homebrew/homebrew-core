class IronFunctions < Formula
  desc "Go version of the IronFunctions command-line tools"
  homepage "https://github.com/iron-io/functions"
  url "https://github.com/iron-io/functions/archive/0.2.70.tar.gz"
  sha256 "0e466bf05147f9e6b760a9c96d03539cf05d9f4bdeef79460d32459386488d45"

  bottle do
    cellar :any_skip_relocation
    sha256 "8723a5d78b75aee947fdf1d8a55db28c260b54f5cab3da5b966333530cca7cb4" => :high_sierra
    sha256 "b38a6b4ba45a0097b639b0f3f8dac1ccede58a7fc7941f219b998938f8b3cbf1" => :sierra
    sha256 "3e1800f3fdc36cdac30dd626ea77211f9e6b3505096a518f8a62e91733b35959" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/iron-io/functions"
    dir.install Dir["*"]
    cd dir/"fn" do
      system "make", "dep"
      system "go", "build", "-o", bin/"fn"
      prefix.install_metafiles
    end
  end

  test do
    expected = <<~EOS
      runtime: go
      func.yaml created.
    EOS
    output = shell_output("#{bin}/fn init --runtime go user/some 2>&1")
    assert_equal expected, output
  end
end
