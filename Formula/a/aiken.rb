class Aiken < Formula
  desc "Modern smart contract platform for Cardano"
  homepage "https://aiken-lang.org/"
  url "https://github.com/aiken-lang/aiken/archive/refs/tags/v1.1.23.tar.gz"
  sha256 "e462fd02ee47546b7e1b42fcca54e4a70410fb0fe0e26cbb9f16f11292b2a5d1"
  license "Apache-2.0"
  head "https://github.com/aiken-lang/aiken.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f65184e76c5db347ce422eed5f1bf92ed85a5d3ed330fdb563a620da5e4e8e69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "725814eeb6b54a36794a17f75e56e93056be91171c7eed4a65a583adfbbd98d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fd508b880d89c9dbc999b11969ccb06e55fb02950cd69ae0d7da1cb62445391"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cc179f1156417c3cbd28713acc08fe26851cb01f303d2df874ad62ada871986"
    sha256 cellar: :any,                 arm64_linux:   "85c3601261ad455b427fef0bc15b18b4d2041f4cd55d1e02f3ae040e0630ab0d"
    sha256 cellar: :any,                 x86_64_linux:  "8d980c15ae590b1ce8b75f1674ae029ff2ac9b5ad7bc17995700ced021cc667f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/aiken")

    generate_completions_from_executable(bin/"aiken", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aiken --version")

    system bin/"aiken", "new", "brewtest/hello"
    assert_path_exists testpath/"hello/README.md"
    assert_match "brewtest/hello", (testpath/"hello/aiken.toml").read
  end
end
