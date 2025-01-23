class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.565.tar.gz"
  sha256 "f735e04002f5028b755e63c77312828e9e268f7bf412581f641be09cb0d9ad7b"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37abfa20d11093b1ccaa9e8bc38b6e8ccfe564e25efb8aa2c0b02bd2df29beec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d9e48747a7e62fa0fc05cc6030201ac3d930ff82de7d45a8f63b52c97b2561e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5df2a3b4a5cdf8a1eeede67a446229713e5e2c4f4206e5e2944bfea0d957af13"
    sha256 cellar: :any_skip_relocation, sonoma:        "456e7cc73c21ada45e667a6758e48d77a40c7615ef38b2813cf652e5bdb96b92"
    sha256 cellar: :any_skip_relocation, ventura:       "7d799eb47ec1110cafcf5bdfc30aa427304bf273517c24f11dd39ec6ad1e8501"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22a6fe8586ecbd602a5ade0cc0fa866b3affe17a41263a4d1a771b34d42c46a6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion=#{version}
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipsw"
    generate_completions_from_executable(bin/"ipsw", "completion")
  end

  test do
    assert_match version.to_s, shell_output(bin/"ipsw version")

    assert_match "MacFamily20,1", shell_output(bin/"ipsw device-list")
  end
end
