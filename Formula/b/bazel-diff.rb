class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v79.0.0.tar.gz"
  sha256 "ca9e3449e613576879165656a45375b2067316d504822bed21e2a7b8ef72cd8a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2f78dda9484e01c22a918e184587392c988b1f8b5c55d101d0eafd2efed0c9f1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e0d485ba230b73dacd1c0b66f0e47cfe9f1ab25b3f573bec63cc32908f1e4f48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9c65a944046bfb0334fccc40876315ea015c761d19309a1b8df357dae84cc068"
    sha256 cellar: :any,                 arm64_linux:       "a3ffd43175d29e5761946c8db1210fc9dcc45ef45dfc9f7bde8466c4490cfa84"
    sha256 cellar: :any,                 x86_64_linux:      "5aefb572c35d0d3cb278fc5e99b364b98ef4604c1520e3ea21ac64341fa4394b"
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
