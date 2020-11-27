class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.11.2.tar.gz"
  sha256 "e06c9667e8da52ee7ecb3597234a3bb72b253663ac49f9d9d6dc97a76adb7e58"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e2e771ff46f2620fd96ae252e5c4c1c5c23b18cb12cbdadd39764c59561cc69" => :big_sur
    sha256 "4f63d558f310fe11327b0199f4e28f18e325da265ee96ea47d6dd97fc4ea781b" => :catalina
    sha256 "dc7d04950af9fb2f7b7b4c6df03831d1d38d738e6ef21c695d157ee51f16ba82" => :mojave
    sha256 "9aa255bcdcac6cba1d05a4902b84ff3b1c13e801fb172a0c2d0c3e19a48219e1" => :high_sierra
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
