class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v70.0.1.tar.gz"
  sha256 "518abda27e0347f28d4e26004a2f20fd1a4025a133f3948c641caa85870ae5ed"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7686e743608e89a818570b35d084fea8219786cf5ec152da6b84fe30c99d12d0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9e5e2843de141ea5e630b0c2a0d8730eeea94af19f911e13b186965e88b4cba6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ec823865db2c4de13d051dd4c12207edee605614c8ac4585b051e2fbd4529d2c"
    sha256 cellar: :any,                 arm64_linux:       "67377f165e4941fcf065ec37262961a158c8cd73dc13399c2d2fd493dca6dd5b"
    sha256 cellar: :any,                 x86_64_linux:      "b0f9c965a9543cfd95edf03ebbef84b3a1b7304a64a1c41d202a279005e0c6a3"
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
