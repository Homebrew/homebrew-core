class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.12.8.tar.gz"
  sha256 "0918fc9ee88ad75f5edb8f49c061a72b9f136b2b1d4e69be49aec296dd69b8be"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "edf25a1db175e3f407153eb05c84b07ad94dd85a75058082c1930f990cebfbab"
    sha256 cellar: :any_skip_relocation, big_sur:       "7a34922736478321fa18c63dd134b313abc5f7437234486d72326460c79ff631"
    sha256 cellar: :any_skip_relocation, catalina:      "bc49ebd84e6c9c6a84747a42cb2e7381ad1cd0e0da465b57f1685fbcf1fffd39"
    sha256 cellar: :any_skip_relocation, mojave:        "04a37f01c8853b757d91c83e8fccff6aa382f07cab4dbdae37cc6e6fb87d857a"
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
