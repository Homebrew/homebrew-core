class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v70.0.2.tar.gz"
  sha256 "bc4314c56d3caeac81a3d8b6c77e0a30e72d6efba74da5e728f375af2d909f26"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dc638f35938da36000d8be23d89a866d575bb14577e56c6d2166f4664380c3ff"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "af040b68d04cb0635a2a0da3df97feb76d9d4a7d4a694efa9923aee751be054d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b193ef495338b47aab86d7f2e1cd1cef5dd3cde1ca990f570abcafe591b097b7"
    sha256 cellar: :any,                 arm64_linux:       "fe29e05bf3310f84fc4bd01583247fdd6ba746cc004b103fff17c6352b54c265"
    sha256 cellar: :any,                 x86_64_linux:      "f22fcdd519e24bdd35e2479d268f137832c9d5e0bbfa689df00bf982cbeaeec1"
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
