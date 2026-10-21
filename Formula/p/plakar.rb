class Plakar < Formula
  desc "Create backups with compression, encryption and deduplication"
  homepage "https://plakar.io"
  url "https://github.com/PlakarKorp/plakar/archive/refs/tags/v1.1.8.tar.gz"
  sha256 "4c3979c43bfc61a41609d398b9e48ca0681b58715fa0a6c256accba8f4627377"
  license "ISC"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0538efac4d572f0c18455ee66140828b0964769c1c2d59c5b288be08ff7e2087"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1d90873ca05bd07c45b169d88a05f12a968d951f4e129efdcb6042b4a80b0f74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7ef02950db3917ed603d22fae51efc34458e21e9a96b428f2a001f7ddefc95b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "235d64feaf65d4edd7bfdc03984ef46cd1652c7428bfbc5b4b2e651101e39112"
    sha256 cellar: :any,                 x86_64_linux:      "15afb82e80a9d6c2ccbe8a7126e722d898407de022265539b7489edbdc8c7619"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plakar version")

    repo = testpath/"plakar"
    ENV["PLAKAR_INSECURE_PLAINTEXT"] = "1"
    system bin/"plakar", "at", repo, "create", "-plaintext", "-no-compression"
    assert_path_exists repo
    assert_match "Repository", shell_output("#{bin}/plakar at #{repo} info")
  end
end
