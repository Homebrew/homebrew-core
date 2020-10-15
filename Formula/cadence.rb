class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.10.0.tar.gz"
  sha256 "9b4d2aa68fc1d85f11c09d877b42d03dee07e4c3d2cae0b86fb0a5ef0efeca59"
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
