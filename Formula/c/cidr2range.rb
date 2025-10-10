class Cidr2range < Formula
  desc "Converts CIDRs to IP ranges"
  homepage "https://ipinfo.io"
  url "https://github.com/ipinfo/cli/archive/refs/tags/cidr2range-1.2.0.tar.gz"
  sha256 "54af7600dc8c775f28d8fdc9debd86154e9293f07eb73f7372931d9c94744c81"
  license "Apache-2.0"
  head "https://github.com/ipinfo/cli.git", branch: "master"

  livecheck do
    url :stable
    regex(/^cidr2range[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "3382d71c74172fa8b5cdd02e8668ab6103ad35ab7f2269ad7f51d0fd2c35ceb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "17e1e7697199411cdab3f8d1be909e6bfa407a2f8017cc142d83732a540bbecf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9368ce012f4056691b6b10d17a1f434bae5c76988d7c6c067e37d73a7e44da15"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7f537be2b192ed4da4662bf9685430324ebeaa0221257b719e7349c94d00831"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec7676939e1927567d72bd8477a34bd7dc614b7fccbacdde465214fa0e115789"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2681a24c80b987299ae03be56a7b0e9fde805cfa6ae297140fd15d9f5822e21"
    sha256 cellar: :any_skip_relocation, sonoma:         "a206f918aa7497cc7b06f79c825c199a9810f8793d3cffaea868c738c3eaaa85"
    sha256 cellar: :any_skip_relocation, ventura:        "ed20ee84a173326de144a8bbd9fc3b9223121a74c06c2bfbae62a9938ba8b5c3"
    sha256 cellar: :any_skip_relocation, monterey:       "488509c006b7fe25a2d366655e12a4cbe6dfe782bac351e3c2fb7c0caac9da04"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b60567820427b73945cea5ce77d6a73c10954d36f82c9f0e1d87aa5ae6d6432"
    sha256 cellar: :any_skip_relocation, catalina:       "89f76772d934321dcf4e6c9417071cce8074a3666946decc12c3d5a861001d31"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d28a210ccb7d1d612f7bc936c4cf66c5a5bcab1e3f8d483f9e08bebe3a834ba0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8d60c39ba96620c8b8cd5f34e81a02365f0c09db476a3e7626670a12e80c2a8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cidr2range"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/cidr2range --version").chomp
    assert_equal "1.1.1.0-1.1.1.3", shell_output("#{bin}/cidr2range 1.1.1.0/30").chomp
    assert_equal "0.0.0.0-255.255.255.255", shell_output("#{bin}/cidr2range 1.1.1.0/0").chomp
  end
end
