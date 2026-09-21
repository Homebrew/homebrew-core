class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://stackslabs.com/"
  url "https://github.com/stx-labs/clarinet/archive/refs/tags/v3.24.0.tar.gz"
  sha256 "159cb56e62abf0f1ed8c6128fdee9d05a8103e71a74debde7cd7eb59ddacc6c5"
  license "GPL-3.0-only"
  version_scheme 1
  head "https://github.com/stx-labs/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0996d006ff34c0d11e79267b9f0b7461601e1a2a140a3ff89d2c0f945dc77665"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "47417898fc4e9743257adaf761dce4e5ccf24b5ff58dd1c499ac71d3969e0f0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "17ce6901d7ffaf6f77c92ea388563129d0825f6616b83101ee5c8e1eed50d3d8"
    sha256 cellar: :any,                 arm64_linux:       "575fee874cb4a5c0654361dd73e7da8c47129edc52975913785cdc8e4fb64d2a"
    sha256 cellar: :any,                 x86_64_linux:      "b626d576d792021b10577ed5ebb4ee1eb1b8d7d49627c070e4461715db121859"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "components/clarinet-cli")
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
