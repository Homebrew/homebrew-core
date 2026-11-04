class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v74.0.1.tar.gz"
  sha256 "d01dfaa68635698eab599eda035ce65316e2e137b61e70bccb9f20d66898b8b2"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1e8977f6517c7e98ea6e936e8199339f6818a614b481c5d0196a3011a9ff78ab"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d5ce7d96f6ed1e45fa35ce5e0ef3321a228908dadec7c96f84bc660550cf0612"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "39e3c9abc232115e19bb091fc3bd75f5dfd9de3e120857c2c22b5b6323cf11c3"
    sha256 cellar: :any,                 arm64_linux:       "3b5a086981ff430a67e249101de71a17675b4564fab9c1ce07c53df862f004fd"
    sha256 cellar: :any,                 x86_64_linux:      "c6460117ae57a559b2a07243d22af8d30b3abdaf9157161cfe0713186191c712"
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
