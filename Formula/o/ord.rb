class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://github.com/ordinals/ord/archive/refs/tags/0.24.2.tar.gz"
  sha256 "9c9167e8fa9307a176f8b90c50cb6bbe0a67011a9d18982d81b78f8021ef2b28"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e91865fc26d5c35440038db3b6b7ac8c11195e772d62f5ac347ab21eceab33f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95c887c380679ef874e5206e274e69168f7b8de1edd891b55a533b2523d7d55f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0639183c013bf05a93d0d28e5286efe6c66dd81e75b686e11bed0521f5db483a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c76f486d447c80de8f6cb6859abab919b7ae68c2423459f975d8d359465a012d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5121e7cfd084d7087a80b914d4a522734b60f21f0ba0eebb6133a7a08c5ea1d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f50ef87c186f360a160ace6aacad963beca15acc3bda586ad323e1f05d18019"
  end

  depends_on "pkgconf" => :build
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
