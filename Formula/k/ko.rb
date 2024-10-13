class Ko < Formula
  desc "Build and deploy Go applications on Kubernetes"
  homepage "https://ko.build"
  url "https://github.com/ko-build/ko/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "85b909fa600309e71d990a522321a32b4eeb0e67111ddb6eb8b34057f064500a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8631b1743c1ff883a6a89b70d38d804e294423d2e9d50b69483086b2811d596a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0a81d1898cb12ae86c15a5a7181dda0572c90338f423caebfee80e28566c1111"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39741725bb79ca8ae6e740876944a1acfd9e04087eaa6c7e569a5e38c4028e49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e77ba1346f207e1333308b8b9076c06a8f6bd0caaa8a2c45235cdbd75f0fc96"
    sha256 cellar: :any_skip_relocation, sonoma:         "48422b2b256c0f2e5251d4e95629198ea04cb2ef5b173a020bba7aebe62713b5"
    sha256 cellar: :any_skip_relocation, ventura:        "074558ee1a12145f58f2a444c31fd90106b211aab4b640e33f8a69986bba1476"
    sha256 cellar: :any_skip_relocation, monterey:       "f51323cd395c4489aa11d8749bbb7b4c518c9e8b77d53c0391f5e7a400f4ec2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "251a9e971ef90ac724c6a0307360e303f6a8d1df4e808b137043fa41084cebca"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/google/ko/pkg/commands.Version=#{version}")

    generate_completions_from_executable(bin/"ko", "completion")
  end

  test do
    output = shell_output("#{bin}/ko login reg.example.com -u brew -p test 2>&1")
    assert_match "logged in via #{testpath}/.docker/config.json", output
  end
end
