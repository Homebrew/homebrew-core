class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v75.0.0.tar.gz"
  sha256 "2c8d82ca3be48e8adfa62d7fdca868b52b753a2161ae6d38b246b162079dfc1a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "812f8987bb52fc8e20c839afa85925911142b09efddd0553f053c17f63b2e0ea"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7886e13d34f8e6a1ad12b61e1d9bf937afc73908971c0d24bd39289ece974af2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "21679af9b8af09d7b23a86574e08cc0d4eb475c93d37f55ccf1d2d34fef7f25a"
    sha256 cellar: :any,                 arm64_linux:       "8543b5fb132d24aa97090383024efda27dc47928b3488dea798019cf244f4059"
    sha256 cellar: :any,                 x86_64_linux:      "a07a81682dbae63d95733fcd7a9474872b8d2878da5a005a2041dbd809879a84"
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
