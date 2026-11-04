class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v74.0.1.tar.gz"
  sha256 "d01dfaa68635698eab599eda035ce65316e2e137b61e70bccb9f20d66898b8b2"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9d083486b8f7e34dce1303c689020b53351e189103d466fa3684095afab6fb47"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b6417bbba0bb5d3e02cbde0b428a981f333bcd28f14e851247f697009ea5ab68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "017ab470ca7141dd9bd178d46cd6599a9b5c85dad93d86690fb5b73f5b70e2b6"
    sha256 cellar: :any,                 arm64_linux:       "81522aa43cf802a5054f72515aa6e4ed6acf7c7b3b1a99c88372b7125447a7b4"
    sha256 cellar: :any,                 x86_64_linux:      "9e6e53293caaa603509ad2324f334967ba4319a12155eac4e31cef30b730a083"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Use our protoc rather than the prebuilt one from `protoc-bin-vendored`
    ENV["PROTOC"] = formula_opt_bin("protobuf")/"protoc"
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"from.json").write <<~JSON
      {"//app:leaf": "Rule#old~old", "//app:top": "Rule#top~same"}
    JSON
    (testpath/"to.json").write <<~JSON
      {"//app:leaf": "Rule#new~new", "//app:top": "Rule#top~same"}
    JSON

    output = shell_output("#{bin}/bazel-diff get-impacted-targets --startingHashes from.json " \
                          "--finalHashes to.json --workspacePath #{testpath}")
    assert_equal "//app:leaf\n", output
  end
end
