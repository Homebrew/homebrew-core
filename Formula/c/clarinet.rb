class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://www.hiro.so/clarinet"
  url "https://github.com/hirosystems/clarinet/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "5614cf24d3182b27ba002e9521eabb2fa05c9003a4987c218f67784b77579378"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fa0cec65edd8678ac7a6317d47343ce3e01e08b1fc8de011f89e592ce148c278"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d2dc26f9fefc8c5ddeee01e8981ec9d08ef61bfb42945e62477a4060bb559f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8f4f2ede28c842b92ecc003a1cb80bbd7d878c73257f9bd923f5470a7ecaa17"
    sha256 cellar: :any_skip_relocation, sonoma:         "75c076a1500a1a8cf26746ac4985656e8b65ebc0c071c5d0912f7099bc68ec85"
    sha256 cellar: :any_skip_relocation, ventura:        "3abe7a9ec77413ca171350e96b1e265e1767c1dbca62c19a588117f217c3b958"
    sha256 cellar: :any_skip_relocation, monterey:       "932d6594399fd2f43c4d0888232ad72f0286390997a9a76feb903d98fa642110"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c579b1124d2f66de2b71af93f2dc5d0f9dc98b5f661c3b73611bff1dd46b765c"
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
