class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/refs/tags/r37.tar.gz"
  sha256 "05bbc3543951d9649dd2427395a171cf8106976afa7bfff27f812cbcea73fcf0"
  license "MIT"
  head "https://github.com/gokcehan/lf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "194e831d0e03e09fbcfa77460c867352e0f3fed6959f3fa3a19172567d66f378"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8b56c6ff35183530c0e4d653aa87da2e0d6aa4e4d976086d34b97dc5d209b42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8b56c6ff35183530c0e4d653aa87da2e0d6aa4e4d976086d34b97dc5d209b42"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8b56c6ff35183530c0e4d653aa87da2e0d6aa4e4d976086d34b97dc5d209b42"
    sha256 cellar: :any_skip_relocation, sonoma:        "80c88cf1be76b8c4db0814cf427f899cd1743995c566d60d6182c52c536100db"
    sha256 cellar: :any_skip_relocation, ventura:       "80c88cf1be76b8c4db0814cf427f899cd1743995c566d60d6182c52c536100db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aaec4650cdd485034708d44d3125459b14174d492022edae31ce5bfa900211ef"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.gVersion=#{version}")

    man1.install "lf.1"
    bash_completion.install "etc/lf.bash" => "lf"
    fish_completion.install "etc/lf.fish"
    zsh_completion.install "etc/lf.zsh" => "_lf"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/lf -version").chomp
    assert_match "file manager", shell_output("#{bin}/lf -doc")
  end
end
