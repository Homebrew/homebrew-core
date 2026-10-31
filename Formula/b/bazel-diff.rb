class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v70.0.0.tar.gz"
  sha256 "ddfe31c6c6ad04bfcf8263cf3181f8e44ce28fdf465e6394f30821a748c37670"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5721953fe6ec8510d5464596f5593bca52239dd84018b68ddef9ff6d5066c741"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a9899e7299eaf29b160f14a51087dbbc095cd86c4b80663e2932b14d6f4d882a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7a1dcfa312d3f4d68356330315610594d364ac603e7ca2ed772a208cf3bc6ee3"
    sha256 cellar: :any,                 arm64_linux:       "d08d7f477e696bdeae7c221cfef7f963a80b946af4916ce2592457835f699de8"
    sha256 cellar: :any,                 x86_64_linux:      "c34cf850c5771ee53cbc7cf7d9c238cca7b7954826fe640b69de82f58c174cb1"
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
