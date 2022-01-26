class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.21.0.tar.gz"
  sha256 "f4163024c1f4e5e119a088ae0b2b5d13521add7f9ceae46afcbbfc749f8ec90e"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c69af3ec073b48331a7432a847046263feae4db5df0f082bc05b93cab8a4131"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b116d2438630dfbd2c588fd851d18dfa05aeb2bf4ca5441a4e038b7483f926e0"
    sha256 cellar: :any_skip_relocation, monterey:       "d5fc0a177e9cf4fbb5b9bc26e5e08877f814cdd0aa3432fb7d8430ec615e7a75"
    sha256 cellar: :any_skip_relocation, big_sur:        "91346dda6bb0eb1541847ae7968f4e1daa9878616c60c6e21376c2951347aa8d"
    sha256 cellar: :any_skip_relocation, catalina:       "3b78816c43c5ed2d88504d6696841324b85091b09a6d72433b24f1af8598aa43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e13cf18c3ec0dd6892d137fc434e944c66974ddd5590efffa55ac7ac0d8256e0"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

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
