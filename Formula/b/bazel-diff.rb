class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v81.0.0.tar.gz"
  sha256 "8eec27c6b2dc30947a22987475b2b1522bce440e39efaedd37fc96512c7d8368"
  license "BSD-3-Clause"

  bottle do
    manifest_sha256 "6c7c0570d99f1de8147adf8917e2977aae5c4f1694d06b2da7db000765869653"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b5dcbf281bbabe7c6d05cf40c2f1a95f1876da1e0941affa57509dbdc8630e73"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "172b605729f99d923535e4b0fab128c3a3f244333348184177ac1dc0e65adb5a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3fc0193b96c0e09c56738e14e0d5fd7c302b724ffc968e85795bded3a614dfdc"
    sha256 cellar: :any,                 arm64_linux:       "9a737f1f2fba67dfbe25bf5ba743ac7902b3c134df3ee977f967d608db889b4d"
    sha256 cellar: :any,                 x86_64_linux:      "4a6d38752f7e3d716cd8a165d2849250f188cc2520e9375d8c9906a7ccc565b8"
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
