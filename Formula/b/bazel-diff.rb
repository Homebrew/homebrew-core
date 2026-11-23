class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v80.0.0.tar.gz"
  sha256 "1f3aa0a8c86da1ea053688398c44be06ecffa151003e1afe0a642fe64c4e3bf4"
  license "BSD-3-Clause"

  bottle do
    manifest_sha256 "bd02ad50db610c0d87f03c0b9b628bb9dad4bd73e9c0791fb93eb00575cc41c5"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "99e41d96353565f69ca3e3aea457a2174b868890bcf15eb58f4726fa7612be68"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "620a4b233d750167b2a613fcb2fe6c4830900b3d31d5a2c88b2c4cf65ce71f59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6ebde033b3baa608dbc563d92352f9472c7b24a86647f2a8fcf735096d04c5e6"
    sha256 cellar: :any,                 arm64_linux:       "31de24f11ad478391c8d34e7533734d75bae45bd6ccb66b1ffaf5d8740f9c7c1"
    sha256 cellar: :any,                 x86_64_linux:      "daaed308a1ce68403e9ad0790c4e67626fceb7efe9340d9d689ec13a111b4a68"
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
