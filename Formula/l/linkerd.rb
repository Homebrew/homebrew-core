class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"
  url "https://github.com/linkerd/linkerd2.git",
      tag:      "version-2.20",
      revision: "7977d505fc3d9ae7dddddd11779a82f813e405ac"
  license "Apache-2.0"
  head "https://github.com/linkerd/linkerd2.git", branch: "main"

  livecheck do
    url :stable
    regex(/^version[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "847f21f61f8dc2de26bbbb3348fa2a5299755bbbb0a2bcb5da96f28e653bad06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdb8c194709b78da6eaaa1b51a91e4c04bf22c3b847f6e6d5c12fcfcca529d5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f2e30ccdd41b8d047e50292b1718cdf0450089718f964dcb33174351dbe822e"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbf1e3708c051367135e0369ed18ce703a17fcf91d5f801376b09ea5d7050381"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8e53b12276dbbd09e55ee1e073084bb4558295173de1ad83f2dd98b14933cd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa8884bcde37cad52a2b79557c62ca573c2c2b3870166c40de9cc41ce12ad83b"
  end

  depends_on "go" => :build

  def install
    ENV["CI_FORCE_CLEAN"] = "1"

    system "bin/build-cli-bin"
    bin.install Dir["target/cli/*/linkerd"]

    generate_completions_from_executable(bin/"linkerd", "completion")
  end

  test do
    run_output = shell_output("#{bin}/linkerd 2>&1")
    assert_match "linkerd manages the Linkerd service mesh.", run_output

    system bin/"linkerd", "install", "--ignore-cluster"
  end
end
