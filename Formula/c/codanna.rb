class Codanna < Formula
  desc "Code intelligence system with semantic search"
  homepage "https://docs.codanna.sh/"
  url "https://github.com/bartolli/codanna/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "766f4a98243886798927a7b4b764216d6adceda04278b16100e108d36ec70944"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ee32a335bee0f405dabb6ae9bd05750af6b6ad4707824591234465b39a2ebfb7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9087438fdde22199222624b9be9f6557096b759e1129a413080c2ddb233ac95a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2ee7b8327f596f22307c2d2a36c1c950b700353d3f70aad0a73dff1fa272d718"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "53709ccbd7c76cf4c858887d5d94ffa1f6ca3719915c08bef08140146a5827c1"
    sha256 cellar: :any,                 arm64_linux:       "933b7acdc2cb30777bb58f6f97ac81d2e6723b2525b3afd7409e2288bf1490bd"
    sha256 cellar: :any,                 x86_64_linux:      "9c1b7339824b25455e888bfeb18eaa0226e57b024ac08307c0f3ca6bf78b7c54"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args, "--all-features"
  end

  test do
    system bin/"codanna", "init"
    assert_path_exists testpath/".codanna"
  end
end
