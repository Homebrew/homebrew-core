class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.12.4.tar.gz"
  sha256 "3b70409c1385c803c91a95f2ac13765fa632f7eeb7d7b11c63fdffffeec14b09"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de1d6480fe0db7045f3dd4afe72518f9d762cb99851e496b6ecfc86c91ee5591"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c9109c7af265f030562e114df308096e5d74bf8f9ab4547a753bd20bc522164"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1aa9d276fba24e46a2b50b4dd088f7e437ad522232f1acfc5be0efd3be4c7be7"
    sha256 cellar: :any_skip_relocation, ventura:        "b5e67df89016daf777b9a0e457c04ffeccfcfbe3e48f61c14ec2f65a00f18d21"
    sha256 cellar: :any_skip_relocation, monterey:       "0f2647916083bbc362bc1f13957e24f0a0d6768908084a86b23b2231ab04e1fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "264049d6dd78d69fcef66689f26379bbf5e5df8c3de36ddf0f11b1818fe07fbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23c779d92a12f244d107db79d41b2fbaba4a362798337a760acac0f9f7710e73"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags: ldflags), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
