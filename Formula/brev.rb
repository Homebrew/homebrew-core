class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.212.tar.gz"
  sha256 "a725fa91696482a48105bc547e0b0a8473cc4e7a6820213ed625b0d83b1a2235"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6369e53448b7b16fd375b9d29703d7104d7213494cc36c0242cb254b7da26ae8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e618d566118763223fb60745fdbc96a9845a73ee396aee081af4c250be75a81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "db4446e94588f386ccef44bfa4c6ac2434e26b76469181e90182aad295370f89"
    sha256 cellar: :any_skip_relocation, ventura:        "0aade5d78519ce71f613f337b1fd50d0a53eb76dc5beea6b129dd697d778eed6"
    sha256 cellar: :any_skip_relocation, monterey:       "2bfe8264ed6c7b75efe19750b126c766d8bbb2c6933c1ba6ee84329203e76309"
    sha256 cellar: :any_skip_relocation, big_sur:        "a133ca59d4892cb7bed3d8fc1dbe8f65450a3415e3f4db20ff8b70aa96f4fcf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "277591c71f038fc45553ab6df7a84f1b5744fbc014e4335d8aa2a49bd7582783"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
