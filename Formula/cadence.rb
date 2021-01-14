class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.12.3.tar.gz"
  sha256 "bb9e3084ba92d7afb05a2751e6ee654f395fc44eeeb589871fa2a86caee55035"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "342ae43e6501d304e73550b3d7aa5aa4d87e5fa58e2048ddc1e9b6a1e8678e6e" => :big_sur
    sha256 "75eea00e2ad0cd75f248abfb7a8497085aa35f70b8dfa073d98564730e2747be" => :arm64_big_sur
    sha256 "bf4c21e40d3f19f04a57ad030912aae5c88db54301f6c2ce1b41ce5cee267976" => :catalina
    sha256 "116cc5a12aea331577faa06f693912d77a3c5f18d17b2e1e566c81dcc6a26d8c" => :mojave
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
