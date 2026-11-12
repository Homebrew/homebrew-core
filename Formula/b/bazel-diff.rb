class BazelDiff < Formula
  desc "Performs Bazel Target Diffing between two revisions in Git"
  homepage "https://github.com/Tinder/bazel-diff/"
  url "https://github.com/Tinder/bazel-diff/archive/refs/tags/v77.0.0.tar.gz"
  sha256 "6eed0894403750ecc37461aaf5feba70834115b6f748f1ac6f6c22f4ba57c2e1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6bf55feaa4a86e1be2a7aff051c1b8310f348057256043dec7c2ef7f342b2099"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6dc3eb53c02885b153b0798d9fdf3597b2eb08058d28352f940622fcf78b48bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e4ffc382faa88a90228827a1872191b814f31ee7b23e7e9b19c00448f67ad66d"
    sha256 cellar: :any,                 arm64_linux:       "43fb515aa8497033016f84e4f9f8146e1cc672196d4ae26474db0c1d9f639910"
    sha256 cellar: :any,                 x86_64_linux:      "709c0df15add94dcbd6a6dcaa01e2b6afb38963226de8a42d1df1ba77e2a2e56"
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
