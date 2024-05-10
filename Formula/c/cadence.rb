class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/refs/tags/v0.42.11.tar.gz"
  sha256 "d5f4b394343a7f15943662394e492ec50e60d310015d859ccf30c0418f52fa7b"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1320bbc16ff4c56c6f8e1a07b9fdfae2beb74cbbe2131120db451d9a70daa3ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "798e154ee0fef8544dbf47dac46a8d14d36744008cf449216c9252dbec8f97de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "297667224b4770db53ed1aa8bb9aa281b1fdd531228524f0ef1a2679d72cd86f"
    sha256 cellar: :any_skip_relocation, sonoma:         "d0b34429cc38dfbaa308bc6427bbb77ca0b7233535270b2f24d452f733463987"
    sha256 cellar: :any_skip_relocation, ventura:        "24dede34e37563de50a6a74fba937b532ca76eb3d41e6c3b83245cbe5e4f34cb"
    sha256 cellar: :any_skip_relocation, monterey:       "0a07999d8a4b2a8ffe8652f964870db598c59dbdc82526da07336fcc7657de39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5f330253d63a2e8b42b48ca44db6ff0f44a6f2a08f73fc72752fe6b64125f52"
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
