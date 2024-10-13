class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://github.com/ordinals/ord/archive/refs/tags/0.21.0.tar.gz"
  sha256 "9270d0d2a6b681a46925b2b95b285fa9583af7a1d71da2f9198b3b1fec400c95"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17269ef0d55ba8a67b1c5ac97b9860f4162d450af91bd5f62021e642f0393ef0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91b126ef90133d3863bb1d2a87b26810c0a74733e8675955100dc01cc4660377"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "420c4ef4e3b463554bebd966ce8a2facb1dc882d9ee6694a0049c200cd9aad1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c8f426b8e7cfce9cabb91daf85c43077b24cff6b6fc89ac6a0bf707f02d4547"
    sha256 cellar: :any_skip_relocation, ventura:       "52c36bffaad1dd137234735102c5d13366fef003d127bf4fc58fe4fd389f3496"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2971d25a4c54573f3a099e50dd3b0923cfab398640e01b4e40b63eece467a6c2"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/ord list xx:xx 2>&1", 2)
    assert_match "invalid value 'xx:xx' for '<OUTPOINT>': error parsing TXID", output

    assert_match "ord #{version}", shell_output("#{bin}/ord --version")
  end
end
