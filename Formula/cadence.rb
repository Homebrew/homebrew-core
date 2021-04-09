class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.14.5.tar.gz"
  sha256 "fbf0a5db17407fac1f7f85ecdb69b695de9627004ca93a228b3399eb6433649b"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "113fce0a55b0e9d26cd2b4bbf6f91eeab87d9812b6d9c2e86b7f899e053b9610"
    sha256 cellar: :any_skip_relocation, big_sur:       "3c3d94b209fd65d1fca3ac48a4693bb1df181daa79b3315cca9cea4fe38425d8"
    sha256 cellar: :any_skip_relocation, catalina:      "66469e7c018a22218b69288c7f530f35a87efc1f22660164d07d593ce2e7af37"
    sha256 cellar: :any_skip_relocation, mojave:        "f9e1efc43abe672768c366cbc788ea3fab07a9fd28378b704cce4e6c40c2b5cb"
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
