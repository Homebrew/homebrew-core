class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v70.0.1.tar.gz"
  sha256 "518abda27e0347f28d4e26004a2f20fd1a4025a133f3948c641caa85870ae5ed"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "13d51348dfb2a3e9f1c72b7242494587dc4b4da6c28959a78b58c42dda4efcba"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "61549186a1e93113b792a563db1597220cd829dad09060cc3b33474a56e830bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6d6745a2fe83d460d365d52f6a52b9083cdea9f0b16063aab9be020436a38cb2"
    sha256 cellar: :any,                 arm64_linux:       "d7c558db3629220bfcef1e78629375306ebde902316a613b227ae671fc003637"
    sha256 cellar: :any,                 x86_64_linux:      "9337fab661b542517c06e95b7b66a2715a97ff406efb2aae993d81913329cb37"
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
