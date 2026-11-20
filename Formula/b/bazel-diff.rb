class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v79.1.0.tar.gz"
  sha256 "763b6fd2478065a6756007f762ee56b9ddbe4d5a42ad2e1536576406fc9ca9c7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3416d21ae5a36553d8d0ae113e503b97fd41a89469377440b800e30346e2d35e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "630e1067e2daeae0d2ef39360b3a68f06b9008e6def92d196db1418d05a45ebe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "33b445d924526cf1f76db638834f503fdce61a098c5f4cceb890f06e12c77ed0"
    sha256 cellar: :any,                 arm64_linux:       "bf456ad9fe2c6e54d06fdb526793ce979b252fe0a2a95d82e098e2833690b27f"
    sha256 cellar: :any,                 x86_64_linux:      "47ed59f3af0ebb84a0e3de19a6b0a9b035faa083294de2e40adf8f443100e43f"
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
