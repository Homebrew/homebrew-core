class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://stackslabs.com/"
  url "https://github.com/stx-labs/clarinet/archive/refs/tags/v3.17.0.tar.gz"
  sha256 "015fcf4ca8aee3ed74dbae58f0d809f2c230bf9e75829305d6a728f7ed1975e4"
  license "GPL-3.0-only"
  version_scheme 1
  head "https://github.com/stx-labs/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8540359683d5f08f03a51ab1d1b5805aa9b829be1b9b60c80f2b786ed53322f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b74c7d7c46362efb423618af8d9c21ffe1c7f6d4e8b4a09750c746e8d3f1b6bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e76f69d948d174a6dc6e18b451ad0fe9dc91e834ff6628c9baed8460722d43d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "65d72c25aef6de62192438a309f21c0704b2383f32c53807614c369a1a085386"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6aa835ea3105c02c3609941f2a9366c62bb15fa70a395bbaa19f78c390e3db7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38d27d7bd69058772df8eb9095d1ffca589ec7a09ef6eecd06dff997452679b0"
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
