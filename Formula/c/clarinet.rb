class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://www.hiro.so/clarinet"
  url "https://github.com/hirosystems/clarinet/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "1e6412c07a6bcea11b53ac27a5d56474afc51920aa9ca239b26f9f539c23a824"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34265518e92d2003d84dd0ac90d6f37d6f7c6d45eb7056a608c4e8e8af5179ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9044ba1e93e9c3a4c55f0cfc8793f59dbe3c707fcf826da3b1f9512bcb6c2d36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca995aa294876a92701be3f7a2c86a4d3be0f94853e28d1bf73cdcca05305656"
    sha256 cellar: :any_skip_relocation, sonoma:         "c0fd72375cb50139b76d26ca5aac9d25c64cf707415403431945d62ddb890a42"
    sha256 cellar: :any_skip_relocation, ventura:        "8135a9ed44f93a24cb981098a9cd257cd820aa6a685e1bcf9beb42f3f83f0b46"
    sha256 cellar: :any_skip_relocation, monterey:       "fc4bbc086dbde300b5219f905daeef7c209f5dccfb8314a6e7e382c172fe9980"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "826c1474d0688257ddd738f0fd20c9be0a243793585507c5e98eb192822b6ffc"
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
