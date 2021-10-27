class Cidr2range < Formula
  desc "Converts CIDRs to IP ranges"
  homepage "https://ipinfo.io"
  url "https://github.com/ipinfo/cli/archive/cidr2range-1.2.0.tar.gz"
  sha256 "54af7600dc8c775f28d8fdc9debd86154e9293f07eb73f7372931d9c94744c81"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^cidr2range[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec7676939e1927567d72bd8477a34bd7dc614b7fccbacdde465214fa0e115789"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2681a24c80b987299ae03be56a7b0e9fde805cfa6ae297140fd15d9f5822e21"
    sha256 cellar: :any_skip_relocation, monterey:       "488509c006b7fe25a2d366655e12a4cbe6dfe782bac351e3c2fb7c0caac9da04"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b60567820427b73945cea5ce77d6a73c10954d36f82c9f0e1d87aa5ae6d6432"
    sha256 cellar: :any_skip_relocation, catalina:       "89f76772d934321dcf4e6c9417071cce8074a3666946decc12c3d5a861001d31"
    sha256 cellar: :any_skip_relocation, mojave:         "4ce46a0ca3a2e66f47689ca41a2ba81b6700da689198c025cb724411b35e2fee"
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
