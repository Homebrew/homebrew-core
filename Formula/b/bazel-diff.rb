class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v79.0.1.tar.gz"
  sha256 "8cdc2d743716ee93dac2a93d4a9be5f844e76a65a628a7c7db00f855c2c672c5"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "73dd3e85288dac83f164898a608c94667d2997246e05592b889aee1eb6e1b742"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a3cc616ad922fa73595a08ef10f1326f102167d1f6534fa11ea60a72a83f5e83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "62daff0498789aa3a2f5825fabe87fcdaf885f65686b9b1a92e575a5960342a3"
    sha256 cellar: :any,                 arm64_linux:       "69bc06456b64bff4bf0d47254e3cdf7c550ae551b0d12272d711f20d38bec8a0"
    sha256 cellar: :any,                 x86_64_linux:      "ec774fc415760699b07f938fa9c6e3ea59d197df3e49e336e6a1638e47220f8b"
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
