class Iamb < Formula
  desc "Matrix client for Vim addicts"
  homepage "https://iamb.chat"
  url "https://github.com/ulyssa/iamb/archive/refs/tags/v0.0.12.tar.gz"
  sha256 "54e3e87eece1aff22e9d6bd6798492a1d23ea5e831e9d0889b51272c7d4f6cdb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7ad26af7c6e67b37a716a7debaae52cef5fd094b53a2d09b13ca300adc1a0696"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ae8082145233f38782b8fd8de0c2b5739f3155231ec1f48147b5b47437b3d22b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fcd60dbdbbaf979557c9d0ea75618dbc374794c17bd9774a800b07a04eb87994"
    sha256 cellar: :any,                 arm64_linux:       "e96726a55d3bd5609a43395877ef2b0484ed88f64ecf763a25ecf7482dfba5ee"
    sha256 cellar: :any,                 x86_64_linux:      "9a2a639f5c13dc8347d4417999c413f01b0d891ac4555818f851849e9b639d90"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "sqlite", since: :ventura # requires sqlite3_error_offset

  on_linux do
    depends_on "openssl@3"
  end

  def install
    ENV["LIBSQLITE3_SYS_USE_PKG_CONFIG"] = "1"
    ENV["VERGEN_GIT_SHA"] = tap.user
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Please create a configuration file", shell_output(bin/"iamb", 2)
  end
end
