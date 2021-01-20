class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.12.3.tar.gz"
  sha256 "bb9e3084ba92d7afb05a2751e6ee654f395fc44eeeb589871fa2a86caee55035"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "8c31a5e9a59b01306129b01f73a38f575306f135e11a756db16652d9c4abcb43" => :big_sur
    sha256 "92462f709868ba30ace7186e9b6fd52f18c630c626b68458ad10f66c0396e888" => :arm64_big_sur
    sha256 "e50c08ff75fe91a8364246f768e6d19781c1e2b55e6c1c22b7f04f465deb0148" => :catalina
    sha256 "42bead94af065c824b3c7ac15af3f5a824f80a8162b0995d2b846470a23921ff" => :mojave
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
