class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v62.0.0.tar.gz"
  sha256 "1768d6987d41013992144a28b0d9309f765a7d7e08ee6c98df15ca5fdfe0279e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b610a0bbfc6413882449cba3fbc4fdf8fed10edd32991e26e0ecabaf52fe6a1c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5e007708fe97d4426b7dde471229f448346d28687f0d6ebe42b8ca83ceb8fe15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9c2c34e8f104d2b197b5627656698d2175ee410a8c267b108fd484eec54507f6"
    sha256 cellar: :any,                 arm64_linux:       "003d4b7e0ff0b71c1bfbaef4980dc94179c4dc54dae6a2181d758c36276a38a3"
    sha256 cellar: :any,                 x86_64_linux:      "8433c4763a11d0d9906a90e3f343c70ae20bb4b857a5242ea57018335b16c3c5"
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
