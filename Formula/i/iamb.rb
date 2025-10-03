class Iamb < Formula
  desc "Matrix client for Vim addicts"
  homepage "https://iamb.chat"
  url "https://github.com/ulyssa/iamb/archive/refs/tags/v0.0.10.tar.gz"
  sha256 "f628cfbd9eba9e8881902b970e9432fec815044ec9bea901a8562ea3ef8f4615"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "3f4f81de183e2c6283515bc022a4e53c103d94627e8522f6385c01f37d009b6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1e1a4d58912f7dad8c353cb2ec05577693b21de7954e33b22e0314ae10039e17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c09591eb3bc906830f85bbc406b20a8a5d1fca0bb3f8809c661d88360aa35d6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2124f6220a2c7354ac1435f15a6805adf0ecc617cd9febdfaae65a48ef58f6e"
    sha256 cellar: :any,                 arm64_monterey: "4bf0b74795aea77ea0e1e10a763550d4a58409aa3a08fa5bdcd9c87194dda4ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "9333e920a2091887b025e048a61544c69c263610f261796b3844001d00084bca"
    sha256 cellar: :any_skip_relocation, ventura:        "94f17c6cffebdd18ed8963bfd933925b9b182cf2879b84c80245f4be9cd1dd57"
    sha256 cellar: :any,                 monterey:       "c0d27624f82d9978f2466e90e7e89629704d890c0d8461e9ec01113d6f1ae105"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5b6775634be6db7388d651436166e5663bad228494564b9d6ea16704b47ce035"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f77262d3d6396f267d57ae41fa0d76d023dc5960ebb0eea743ebff4b9ea7f245"
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
