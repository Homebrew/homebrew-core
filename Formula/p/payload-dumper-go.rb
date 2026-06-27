class PayloadDumperGo < Formula
  desc "Android OTA payload dumper written in Go"
  homepage "https://github.com/ssut/payload-dumper-go"
  url "https://github.com/ssut/payload-dumper-go/archive/refs/tags/1.3.0.tar.gz"
  sha256 "d7ba33a80c539674c0b63443b8c6dd9c2040ec996323f38ffe72e024d302eb2d"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "97ce35198d98de962751f7815760e8ba1a9887feb3b999aa65f68a04d2e47e57"
    sha256 cellar: :any,                 arm64_sequoia: "298d73ff6bdcbe98ec51938eda5d6df35f4a67eb48538ab3d0a8d5e7f5ededea"
    sha256 cellar: :any,                 arm64_sonoma:  "a6be6a71b98e5cbccf85f5fd5ddf49ec28792545ebdff739a275c6c32a7ee34c"
    sha256 cellar: :any,                 arm64_ventura: "adc25ef9cc348ff0f4e72aee84a8d73d4eecc77ec8228b8ef451a1ba52947a3c"
    sha256 cellar: :any,                 sonoma:        "43c27225c84681b696cc133dd3027dcdb8a99434eaaae57adf9d24b10a761b09"
    sha256 cellar: :any,                 ventura:       "9a7fe312cc474f61625712007bb096a34ec93fb165afe887cd2786c7fbd71ee1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f89b0e2f2ffb8fc2ec9c58f91aa50ea18243bbb2c15c4682df72931fda29c21c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dec1676646bcf9b015900ac1d9c7f5f1912671bdd034e511235b38c95e63cc3c"
  end

  depends_on "go" => :build
  depends_on "xz"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    require "base64"

    (testpath/"payload.bin").write ::Base64.decode64 <<~EOS
      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
    EOS
    assert_match(/Payload Version: 2/, shell_output("#{bin}/payload-dumper-go -l payload.bin"))
  end
end
