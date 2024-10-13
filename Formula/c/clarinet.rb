class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://www.hiro.so/clarinet"
  url "https://github.com/hirosystems/clarinet/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "477f0c71ad34152cecf284586055aa9273eff049b11d128857b399aa20f50790"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1058535c8a60c2326feb79839b60e22050a42c30a14de9c2f3cd85151720d67d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a7ef3bcfda0ca29afca3259d8e076b3de6e8d4aad090f286b1fc7e34a1f65be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f13870207362567ed0f3eada5e33e7cf3f98cb0f67b66659fbf5430a93485579"
    sha256 cellar: :any_skip_relocation, sonoma:        "be0a7aac22ec0916d208e5250acd3333a22603e6fdc0fd1268d2daf37be9d6d5"
    sha256 cellar: :any_skip_relocation, ventura:       "8209e5d749203360c7763107710ebcad9e41c00571ae996fcf314162fc124189"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3b101c0cead48b48629719fa187df7654e419eefab9c8d4f167be273c1d4db0"
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
