class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.29.0.tar.gz"
  sha256 "fae78ae0396bba1cdb930fc696cb43951b09dea002eee2cfbbb16972e8749f14"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97da32a239d02954a4893b7a03e34fe66c8d2e0227c891c91c99b12d7b5e15f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a1ce72227bf733f97d2e632f68c82c694c1c4cdcd0871985cd90243da4044d7"
    sha256 cellar: :any_skip_relocation, monterey:       "2db89d91afa474ced05d9675d7730b4f1e007b6c7e1253079d9ffe28f3ed7d8a"
    sha256 cellar: :any_skip_relocation, big_sur:        "6feb8d1c44ead9ec1bc05ba43f3b8f46ae39cc8a13eb50d7536534c819fa3f3b"
    sha256 cellar: :any_skip_relocation, catalina:       "5e931e295bf4a6168cf001f21e05bdcadb9cb774efe740e86d612e7d92baa5e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97d0c84efc779a834bd74b4e73de02c5951b1c5d43953b708ce10b3ffb881156"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./runtime/cmd/main"
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
