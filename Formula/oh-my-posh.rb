class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.40.0.tar.gz"
  sha256 "08e11ebe2a0c8961e957a017c19104daa3c4357c3e58b2c362fb50471957504b"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac025f3af8f5a70c005e70367543312f898f56cf88fb765528481b310785d36b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "054c1c24d0314b031f4f0e5421749f34f0febb10628c8eafa623a9ad769fca82"
    sha256 cellar: :any_skip_relocation, monterey:       "4762735ab1cd36cf3a0fdff8d263ac4399a8474e0fa76f3263a07ee23bf0bd5c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e23032be2bc693b885334551ca073243dcb153af28477a8dd8b27399c8b1805"
    sha256 cellar: :any_skip_relocation, catalina:       "a7f3b80816f452493ff81485478af03580e51a033eae84a9d945f545e8cb7141"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a33b28788d3d6517596d631cd9090650e4c91a81af4c8c38cc5c7764ac9723df"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end
    pkgshare.install "themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end
