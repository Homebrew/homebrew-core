class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v76.0.0.tar.gz"
  sha256 "016c2afb16270dfc093b87e3223a1ac81e153548e663bd789f66e97c0b2a21b7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ef4805fdd7a94bc25a90bc8c864633d9f6e12ae9548096e4b85edbbec2bcd76a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1e34096044c6f3d4c6a00be81d435a288e75911aa856f126347049c2e351d14d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "767a8ac504d284df950250d575461280ecd1d556d84db758d04fa7d69629284b"
    sha256 cellar: :any,                 arm64_linux:       "9551d220a9ddca3d170f7441716ec448e1a823e8a3e348514d13c3013574d5c6"
    sha256 cellar: :any,                 x86_64_linux:      "8e5552fa042bfd0f6f32d85f1bd0b066cc780d444da19838559c03e6d73e2d16"
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
