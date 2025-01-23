class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://www.hiro.so/clarinet"
  url "https://github.com/hirosystems/clarinet/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "0afe6a2ad612c97ce3e1abe8d4bb2359fb557f5c1e11a65362bd08fb55e7c542"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fffcbe661877bb2354c84f80177e00ef35ca86060d312defc3b547f4d474c4b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5acafd900d476d0c35c97bec825e9eccffaeb43f306c9a2b8974b8c38f53f2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62c60796f9b4a20e576d34b8b1f1d2d472b4d642f58883a2e485a1a68bab7459"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4d553d2d7b8e7626b31dc343e8afde180e177379840e412cf32f7b45810b96a"
    sha256 cellar: :any_skip_relocation, ventura:       "e9b95a3b15460bca97b170bce06c6d2334439378f631c1ef9b3e1a9f4602bd07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe7a6db685af160134a88ea14249bea343298b9ffe6575e1276b62ad7e0b4893"
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
