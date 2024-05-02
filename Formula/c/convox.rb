class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.18.1.tar.gz"
  sha256 "02261f33686a5fbbf55b8811a9fb721dfa227dc63d37210974a329f18ae7f9b1"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "098871fb5a0a347b7fb937f20f61a792b963bfe8796558e427638c775168f302"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a098ba85ddd206252211747be0f22c71d879f40318e8a624ece1ac1c3c2c3ffa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52d6af7e5ed02aa8ebc4590e9096b4a3a3fb6b5d1149aebdb81c83658dcef08e"
    sha256 cellar: :any_skip_relocation, sonoma:         "afa8be415a133b07d39103f05e71db8fb51ff52faf70a72d470488470a51494e"
    sha256 cellar: :any_skip_relocation, ventura:        "2777eb68b17ee41fd78e0fa41f42ea1eaf59d92d444956cd0e844bee1827cf36"
    sha256 cellar: :any_skip_relocation, monterey:       "fc2523eacfda4489f3036d6259556f2079e31be51bd66fe95e1d10b041108572"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80e47acb4ab170a205d82e111dd46cfe17e02c14988ced8fc753e08c62e65c44"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags:), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
