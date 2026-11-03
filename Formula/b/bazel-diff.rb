class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v72.0.0.tar.gz"
  sha256 "4c8974c924da65e04ac7b3fb8eff764422a4c2b915e84a506780dde5b570f817"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a9867ec01356123cd3254f9dd382abcf2c5e8b0be84d2882f0c43d1aec0214ce"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c01eb18093d1a47afd424355b243714f7ba6201b5fe2647eca6a5f6d14242fa9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8181a79282cf6d86eb597c0befef2027540967c388991779ab2b7fc7fa1b622c"
    sha256 cellar: :any,                 arm64_linux:       "850926ce784742afd7c5e3bd633850658649589c21da1bfef4ea791c1de21922"
    sha256 cellar: :any,                 x86_64_linux:      "9d7e1504b2e0ab633d5c59171625cff88792704a797a837b331e05f3bb720a99"
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
