class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v73.0.0.tar.gz"
  sha256 "b088ccdec25c89d4110927b4b358e05f2bf060f4a9eb7719ee1c7b00b6d4e7cf"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e298ffa7448a2b3bfe2694b8643ab3bff76f5765d8040377d6f4b6235d2f644b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "abecaf92884e45ff6fc342846e7395b6d43f6ac4af1d16a903889cd4b28e09c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a2e8aec3300a6331715e75eda54fdbe5f09e7e227a9a2d07aefd04c277bba085"
    sha256 cellar: :any,                 arm64_linux:       "17c058c77e77d34b934b631daba4ab44303c4b699e931e9bf3f1363bce405b1d"
    sha256 cellar: :any,                 x86_64_linux:      "e26104be46c0a5aaf6d74cbe94c2c0b20fba3786872c9b8187ee590211c44499"
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
