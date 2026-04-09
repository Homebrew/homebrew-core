class Jaq < Formula
  desc "JQ clone focussed on correctness, speed, and simplicity"
  homepage "https://github.com/01mf02/jaq"
  url "https://github.com/01mf02/jaq/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "c56948c90d0c3566c8b33eedd9fa61587ffbb2feef7d78172955876d6e10a315"
  license "MIT"
  head "https://github.com/01mf02/jaq.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53f2edf4b3fa3da6b77deeb1960a8889ca0f6fb539fd041a0a30d4aa6b61804f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d19a263d0983a297a3bb112a32cd739128353bf702f08ecfacde13f9ae616d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e753b14777e29346896f1d37493df5a4482bd4e859b100ba4c063e7daeda495"
    sha256 cellar: :any_skip_relocation, sonoma:        "b661d5054a5e3793d16ef811bb1454f7611974530f46e068ab0b02e5fefce503"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b882046025138feaa16e593e9aefac9d18939b0b96723420b68f51c54775f10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b90f22a7e618f081712d286da22e27b44bb70ba96faa72028ed5cc164ae8aba"
  end

  depends_on "rust" => :build

  conflicts_with "json2tsv", because: "both install `jaq` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "jaq")
  end

  test do
    assert_match "1", pipe_output("#{bin}/jaq '.a'", '{"a": 1, "b": 2}', 0)
    assert_match "2.5", pipe_output("#{bin}/jaq -s 'add / length'", "1 2 3 4", 0)
  end
end
