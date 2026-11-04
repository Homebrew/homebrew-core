class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v74.0.2.tar.gz"
  sha256 "ba31314c97ae5bac043c94010ffe94ffa0e3efea95a1b1d4871a86b0931c1733"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "175f6abf5c7b5b5188cc9bf669079fcefd066f6f63517a1da3bd3e5b7aae6ac1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "845ba4aaa721f3d15759ef9dabf91954066e64ee082241436b4bd791f6197a34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "619c3960f3de3caaf51030284cded294660c802f6119a95bfec2cab7e1ec444e"
    sha256 cellar: :any,                 arm64_linux:       "7cddf689d1e702f687d8c7bde031a13ef4ad7cbe31b376e3d575d581aa3fa229"
    sha256 cellar: :any,                 x86_64_linux:      "512f7128a9fa2d8297c2376645fea7ab5b5e472544238c39425b2bfa2775edda"
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
