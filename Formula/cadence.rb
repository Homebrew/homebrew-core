class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.37.0.tar.gz"
  sha256 "73d8d9f1bcd102c9726abf7fcbb892d951aaf556b7e005e900542f3d37b8ad49"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e87c27a07d6220c2ac284146f140195bf26a73717b458dfb60b6c0953c1d759"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45ee3905abbd107b0e8f731d4fb9de099c6727ee7edfca4775bd5ff2563f481b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "afef491bcbd18ff233e4550218bc1b715628ef3ffc7f4fe356aabb581fb076ee"
    sha256 cellar: :any_skip_relocation, ventura:        "9cc5b3e1b1260585f3486e08cd03d50d4e422efc965222a6e954943dd3865957"
    sha256 cellar: :any_skip_relocation, monterey:       "2a2a1a1f77b4b5610aa7e9794f5f34c9a22047538116480552cb796ca5e47ee5"
    sha256 cellar: :any_skip_relocation, big_sur:        "5dd893185e0a15a753a47f8471e75ebef0d9b3b7e651dd65d8d8672bce39446f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d802fc204067e5c34a16596aa044bffeceaba344c03143466a12e53cb49f2214"
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
