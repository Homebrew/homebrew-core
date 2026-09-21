class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v49.0.2.tar.gz"
  sha256 "44f5fcc51431c258f216f67b2676d41c7562d5255577ba8219a3ec5b16eb248e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e40699dc3b4330fb73365309116896bdec2a087536d0864b972cb1ac8adfda7b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3206f0a07b3a6d920e35497f1a610589024572fb91ef0c9db5320424a9d03d2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fce137d2d7ff7f1c8b908f7581d2ab9fa4a9694b4b968d9bf6e3a8407c0c0fee"
    sha256 cellar: :any,                 arm64_linux:       "e69eb42475120b2d0218c4093b78e8cbf2341757bc7dca1901c6758dd57f2363"
    sha256 cellar: :any,                 x86_64_linux:      "9c3adbbf9ed3bec13b887308c95a4342da84da7c731b5a3fd672b2752a82ce09"
  end

  depends_on "protobuf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
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
