class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v78.0.0.tar.gz"
  sha256 "4d7de65816aa651244b7a86de65430cb6350e0d0aa26a12b1e5582be635b9c60"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ac1cb5704bc3e4d0ed8a0b33bb8392f2b247d85403e24a2650379822b6c054e6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4209dd098b3a243aed4fd669a974f67c860e29487eecfc7970810b43b5059f9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0fac5b7bb245a51ec5aabcec37b1f1662060f906ee376b0d4f6c7289bfddf5b6"
    sha256 cellar: :any,                 arm64_linux:       "3f9206f44c994fb5334b2b1c577ee419ebb820f59010fee4d1589f2599368921"
    sha256 cellar: :any,                 x86_64_linux:      "75d7ea585862c223ebd5f060ce906392ca79b578c220b8456578140553b99be5"
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
