class Bao < Formula
  desc "Implementation of BLAKE3 verified streaming"
  homepage "https://github.com/oconnor663/bao"
  url "https://static.crates.io/crates/bao_bin/bao_bin-0.13.1.crate"
  sha256 "77595dfe39d18bf2c3b6a98b0998d5558461653560c209498007f3ca4c392863"
  license any_of: ["Apache-2.0", "CC0-1.0"]
  head "https://github.com/oconnor663/bao.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d536920c98ba7cdc59be1e52cf4efeb312d8d24817bca8efc38c91d86f3e555c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6b7036473864fd7fc885910aae5c8b43404d5ddb208c13259c9b94aa8f3957d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0834b21ae3308c428a8f600306d8df40d983c281fc64cc11303bedfba5e9c474"
    sha256 cellar: :any,                 arm64_linux:       "4b6358378f3448609c17a8b7d52305f7bb9df3358267421fcbc92f40149bb7e1"
    sha256 cellar: :any,                 x86_64_linux:      "d5d91c4984c6db2cf6d787eb5a9ed1946ccfe67ba1df0d8b8dcbd311e624d2d7"
  end

  depends_on "rust" => :build

  conflicts_with "openbao", because: "both install `bao` binaries"

  deny_network_access!

  def fetch
    cd(build.head? ? "bao_bin" : ".") do
      system "cargo", "generate-lockfile" if build.head?
      system "cargo", "fetch", *std_cargo_fetch_args
    end
  end

  def install
    system "cargo", "install", *std_cargo_args(path: build.head? ? "bao_bin" : ".")
  end

  test do
    test_file = testpath/"test"
    test_file.write "foo"
    output = shell_output("#{bin}/bao hash #{test_file}")
    assert_match "04e0bb39f30b1a3feb89f536c93be15055482df748674b00d26e5a75777702e9", output

    assert_match version.to_s, shell_output("#{bin}/bao --version")
  end
end
