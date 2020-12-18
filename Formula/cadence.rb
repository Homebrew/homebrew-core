class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.12.0.tar.gz"
  sha256 "4dba6467f11b1aae899a1056cf8835475a12d85bc799449492253dba055e429f"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d2965c8a37ba607c5215c318a5f148617f0f2e382fa13f23d8dd5485da87d5f" => :big_sur
    sha256 "b5861b9cc5836dc3e9c08a9682f4fe0284fa8970f21c61a99c063979b67ffc04" => :catalina
    sha256 "f81fcd84d6cdca3446669ca5680a109e6dc876a6c00477619d5ac59502668f52" => :mojave
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
