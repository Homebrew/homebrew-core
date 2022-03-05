class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.32.0.tar.gz"
  sha256 "5a217540a59a47409a9b96053c7733109d828202daed507b43c7dbff7810774a"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cc6a1bfd1881689ebf476ab3434f79db7e03a57caa87837821b076034788859"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22f7bed285227f1fb3ef73e36fcf9ab7fbcb8a45a5068250b68df256f75f08d6"
    sha256 cellar: :any_skip_relocation, monterey:       "d9c84dff92d261d23c0443b82e60e4ae6fe3de666270d5024ae32063d35f4bf6"
    sha256 cellar: :any_skip_relocation, big_sur:        "eed5e280b68669d8125e363f582aaae4bb967d0e7f87bd0fa4ff3381a4086d26"
    sha256 cellar: :any_skip_relocation, catalina:       "d5b1a2e2c46bb39d76d43bc067370c9788271223013a6548ff4a26e59ec145a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6318f4a6498544299a52f044040e53d91e15d0fd429897e7b5694331f92eed0a"
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
