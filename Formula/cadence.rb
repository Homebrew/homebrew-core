class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.12.5.tar.gz"
  sha256 "610d9c2951b0b2f7d1f9a6904daa48b74744561c0f132e9262f2c63ca72ead39"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "dc30b51c42a4d9f844a26d5f6c3d501c5fafb4cb97e576384b9750746766851d" => :big_sur
    sha256 "59e2f5bc57a6cea1397c1715c18903eb18fedd7068cd6c5e63a479d3c670499e" => :arm64_big_sur
    sha256 "12a78b98530d8daae584ecffdf922743e1d61fea0c3e931afef4c10db87c6a7d" => :catalina
    sha256 "959ca61464d50839d09cb892dbc5b02f0f4bc428e7611db8c95ca22e5acd897f" => :mojave
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
