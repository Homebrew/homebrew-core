class Certstrap < Formula
  desc "Tools to bootstrap CAs, certificate requests, and signed certificates"
  homepage "https://github.com/square/certstrap"
  url "https://github.com/square/certstrap/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "7a016b02ad2fbf6a1c6dd010561b6bfe16add5e58d039db5d9ad8fcd724657e8"
  license "Apache-2.0"
  head "https://github.com/square/certstrap.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a7341c7aa9cc1bdfcdd7fadaadf684fdf32edd25f519aa1e2d59f67b4c8100d4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a7341c7aa9cc1bdfcdd7fadaadf684fdf32edd25f519aa1e2d59f67b4c8100d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a7341c7aa9cc1bdfcdd7fadaadf684fdf32edd25f519aa1e2d59f67b4c8100d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a5c5a2061d82e3707c566464a5dd250960ac062a2060c46a6206826f4fb22298"
    sha256 cellar: :any,                 x86_64_linux:      "625653ea662caee3e27c0ec38ff950c01b4d28682170bb1f7634ad818bbb6dc3"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")
  end

  test do
    system bin/"certstrap", "init", "--common-name", "Homebrew Test CA", "--passphrase", "beerformyhorses"
  end
end
