class Ko < Formula
  desc "Build and deploy Go applications on Kubernetes"
  homepage "https://github.com/google/ko"
  url "https://github.com/google/ko/archive/v0.10.0.tar.gz"
  sha256 "55431dcb5c3c82cbc3e636ead9d04d5798154abe1f601785b99923be35b3d2cf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2edbd38b5717dec61eafe850498e776d783836465c5d862ead3c1a511ece6a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab0130285a6ce75a72d33f78a4ffeaa01b0b4aa2998097edae44fa5324d53735"
    sha256 cellar: :any_skip_relocation, monterey:       "7c57d0cda9c59f43e4b8cf61b075d498b706fc9e2fb163deb30286c1cb2eb6b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "3850808505a0747473fbc646ea347f1b01acc1e44e1bf5a16b1790933766c55c"
    sha256 cellar: :any_skip_relocation, catalina:       "193ff82749883ca1051787a730884c9095340bfc9f2db41aa1d5b5a1a436a38c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cdf8a98f1a2636fc098bc36e15feb20cd6547d3a346883fa6a1bedc9a5d1635"
  end

  depends_on "go" => :build

  # Fix build with Go 1.18.
  # Remove with the next release.
  patch do
    url "https://github.com/google/ko/commit/f40d2dcca1b613531fd8b096aa841eafd3e9c931.patch?full_index=1"
    sha256 "a1ef41b7c9db2aceb5fee0f38a2b63ae88c12c506564bbac38a4aa0ef6e639e3"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/google/ko/pkg/commands.Version=#{version}")

    bash_output = Utils.safe_popen_read(bin/"ko", "completion", "bash")
    (bash_completion/"ko").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"ko", "completion", "zsh")
    (zsh_completion/"_ko").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"ko", "completion", "fish")
    (fish_completion/"ko.fish").write fish_output
  end

  test do
    output = shell_output("#{bin}/ko login reg.example.com -u brew -p test 2>&1")
    assert_match "logged in via #{testpath}/.docker/config.json", output
  end
end
