class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.11.0.tar.gz"
  sha256 "2179037268365b8a9afff107d6df272929811387e558d2b68b0b9b3b412d81dc"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "718fcda4dd48a778139e2bfba19c98208074fa1a3c2338f9f93950a87d14ac01" => :catalina
    sha256 "59e7ad5f158e86d94a3f2ede19394d180997f0ec94b4c00f132591c46cb70ef1" => :mojave
    sha256 "71a9048b498f8ad3e03201e94394b666f88325c6ff2cc9247855696834d2e5e2" => :high_sierra
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
