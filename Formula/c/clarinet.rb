class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://stackslabs.com/"
  url "https://github.com/stx-labs/clarinet/archive/refs/tags/v3.25.0.tar.gz"
  sha256 "be5047f990e2fbcfd17e99b5ab716a0ba6724f9a8c47c4efd20fc376ee8ae571"
  license "GPL-3.0-only"
  version_scheme 1
  head "https://github.com/stx-labs/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e61e9e1bbe46d8ad36349053e87269d5a8a7a04168cc59c11c750494271fcc4d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "43a0da29fd18624b0ffa9e26a8516c960a573cf93800484507573aacf502a01d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "826f6ffd3f4aac0e9bd8d4e691581d136df9fe9836e1b72ca29573387af85a23"
    sha256 cellar: :any,                 arm64_linux:       "fcb6f3fe07b1364a0797092c8c846398d82f8a2209429f05a12e5c2701a59567"
    sha256 cellar: :any,                 x86_64_linux:      "60221108e01c5e63409a311aec5f16eabcdcea0993a81bfbab5c8ffbcb42d5a3"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "components/clarinet-cli")
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
