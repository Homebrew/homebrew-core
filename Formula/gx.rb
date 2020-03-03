class Gx < Formula
  desc "The language-agnostic, universal package manager"
  homepage "https://github.com/whyrusleeping/gx"
  url "https://github.com/whyrusleeping/gx/archive/v0.14.3.tar.gz"
  sha256 "2c0b90ddfd3152863f815c35b37e94d027216c6ba1c6653a94b722bf6e2b015d"
  head "https://github.com/whyrusleeping/gx.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "27b47543cb451bb207d36da71a004a97ca725b253dcd72a7733bc2d35e4275ee" => :catalina
    sha256 "684f06520e421a1bff37db9419bec73924826428953b4dc5227546f1c94819aa" => :mojave
    sha256 "c60a535b2e9de4688ba699f4012527d25912b74ef9be40ff59fe5d3e6222000f" => :high_sierra
    sha256 "9b9092d6ad1d055c601e555afb79b41c5eef4f6a7d0e70e1e57ba82580ac3bd4" => :sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"gx"
  end

  test do
    assert_match "ERROR: no package found in this directory or any above", shell_output("#{bin}/gx deps", 1)
  end
end
