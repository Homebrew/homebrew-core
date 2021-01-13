class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.12.2.tar.gz"
  sha256 "ab4e0ef1193edae602250f0a554cc654bef87839b0442d881b4c8727e58ba791"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d8b1a348b96e3a609cabc4e3910941b2d65761dd3c083ccb853edb6aced378ed" => :big_sur
    sha256 "b6f3df53c606b819beea13c8d73dbd08fb68a187df9a970395e45fafc48b80c5" => :arm64_big_sur
    sha256 "fd31ff5292ad3ebc3a7ac82b53ae1c9a5d85d74102a4cd6365dfbd901f98351a" => :catalina
    sha256 "d18375acda46c646b6dc28236085714b33780be2957ea3a80220c7e8378ea6f9" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./runtime/cmd/main"
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main(): Int {
        return 0
      }
    EOS
    system "#{bin}/cadence", "hello.cdc"
  end
end
