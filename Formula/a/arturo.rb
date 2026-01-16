class Arturo < Formula
  desc "Simple, modern and portable programming language for efficient scripting"
  homepage "https://arturo-lang.io/"
  url "https://github.com/arturo-lang/arturo/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "408646496895753608ad9dc6ddfbfa25921c03c4c7356f2832a9a63f4a7dc351"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bec0bf611d5b163f27570f515cf75ee10fba14495abe8968de89f14341b330ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "491a45db95d74a0ffa6eb7c14a331a0a143184c0ede7b009932b6a82bf9023b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96b375631ac5736b75de2936ddc339403a9d43316a6f235befc2645bfcc20e5a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0516e45a8542660710b27f57be323b2d6ef9195659d3a58148fa2a9fb3a74325"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae4e0d88082826a38c7370c47bc7d99ce8ae6ce30e5e23af8859ea92a794c6eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f93afae9df508cadacbe60f96b2c73f8fd2f276181cc3da9d8b5ef81d804c24"
  end

  depends_on "nim" => :build
  depends_on "gmp"
  depends_on "mpfr"

  def install
    inreplace "build.nims", 'targetDir = getHomeDir()/".arturo"', "targetDir=\"#{prefix}\""

    system "./build.nims", "--install", "--mode", "mini"
  end

  test do
    (testpath/"hello.art").write <<~EOS
      print "hello"
    EOS
    assert_equal "hello", shell_output("#{bin}/arturo #{testpath}/hello.art").chomp
  end
end
