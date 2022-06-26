class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.24.6.tar.gz"
  sha256 "a488233735bbcf39f7ac41d53cfb79aa5399af7fd958d853a0bc85332a21e283"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1802dc6ccc3a8856584ded5d763ae541595044790df6c11ad5104d46988fa7f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e62d00ecfd0858e7852098a2e2e19ecfe95703aeb9ae034926b562e2a19e712"
    sha256 cellar: :any_skip_relocation, monterey:       "145416c7528c1a5cd595a4b4b4d69f2a35d294f55d9f9fe9b831c95014e8650e"
    sha256 cellar: :any_skip_relocation, big_sur:        "8cf68dd8812ad0988d636744abba1e2adc0b681d95cead82e831e7bc3c423d89"
    sha256 cellar: :any_skip_relocation, catalina:       "1373b3fa6bac5ce7d55d42d85b3e8c09ed48a235c8ad36a3c72bc5d4ac489546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d8ed9058ba229956351ddff328ad458fe97638827a81a39b3ce044b87c851f6"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

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
