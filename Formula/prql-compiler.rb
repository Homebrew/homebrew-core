class PrqlCompiler < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/prql/prql/archive/refs/tags/0.2.8.tar.gz"
  sha256 "e842beb48d309f5c2e995d26c8383f893ecd3a167dc785cf1597c0526cb484d0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6fe2b73cb9b356e09020c9cd202f5a57a70f9fb9262a0fc1b2c38c4f23722c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6ba6837c655e7a94791c3a1a4de21b66fc2e0c5442eb006c09df95d293516ed"
    sha256 cellar: :any_skip_relocation, monterey:       "c00cb99bf10729750459f14dab6ff2946b264427a1e8d627e6d4ecbbb216a5ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e83684eb992ff2994d5f485839c7bbdedb12dfc96f7dca8954a4e94a90c7a3b"
    sha256 cellar: :any_skip_relocation, catalina:       "405b4f2d49fafbe34e6bbc0c2dd6751cff4d86ccddfe9b806ae778650b8fcc58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a19ecfd7d2547b0434b9c3598eeb12faac3845ea78facfc1199712dd77269dc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "prql-compiler")
  end

  test do
    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}/prql-compiler compile", stdin)
    assert_match "SELECT", stdout
  end
end
