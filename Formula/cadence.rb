class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.13.6.tar.gz"
  sha256 "1592074a0b66e9582fe8969d9a850218c401cecb67d3b03fc823e7c471a6d426"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5d06c7764c00faf563a7f02e1e4f90a0c1a5eef66c71c3b68d69f6535ef629ad"
    sha256 cellar: :any_skip_relocation, big_sur:       "1fb34aca981a872d53fdde2098d7105c02231edef77c7230701b09d8f1b48c9f"
    sha256 cellar: :any_skip_relocation, catalina:      "40e889fb4b6ceb6501e9ed6c50d2a7b78a89a39bdc54fe0fae071cb39788775c"
    sha256 cellar: :any_skip_relocation, mojave:        "4a4d666461b77e9141f84e134dea26966464c20732eed50b903bf468c63825d2"
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
