class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v71.0.0.tar.gz"
  sha256 "bd7ae8f25cfa1bc2027566d6d955757c8270cb3ef6bbe0a1392507cc7d50f438"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fd331d966c4b7da905645e52a7ecd72ab887beb6d701e97c071dad5a06a05874"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "df10ac75d0f1368e65068056425a0761627db82aac0e10c85b93e6e0d5d1f5ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7757cac735616a0166c998c570ffc1d9c2ef6b8151bcf3e28cd6d6a475465d36"
    sha256 cellar: :any,                 arm64_linux:       "7c536cb2773d75eb861137fb92f8184f3153bb49fe973cfd4b4177d0599b0e8e"
    sha256 cellar: :any,                 x86_64_linux:      "bca31dd5da94e6ce194c87467672b58e6b3c13e860558d22c10ee3124a9551ae"
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
