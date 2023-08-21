class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://pressly.github.io/goose/"
  url "https://github.com/pressly/goose/archive/v3.15.0.tar.gz"
  sha256 "f301fdd7df5d05c6c1f8eb358f8aaa8177afb7e5d28064586cdf00bd6e5677ec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52564b1b61f905e070adddac71f6169b0962dc9031331a13ba1f79c08440322e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc8a741eaefcb5331cfaf16427d7d117953f2634f758d0ea902a47f8e20fd7f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e6b41d135b82ec35f8d9b97c6e2df0285821e004edd6718498e16b57a7693795"
    sha256 cellar: :any_skip_relocation, ventura:        "22d5c4e118fa8d62c0bc5b8f984d9af3eadc4de982c27696fcbe8532558f9155"
    sha256 cellar: :any_skip_relocation, monterey:       "df17ddf1f93b83634cd43bd2025e0a06520502ee20baa201ddcd7884225ff420"
    sha256 cellar: :any_skip_relocation, big_sur:        "bcc9f61a3b2d404c08b9bca56ea6ecfde10fe7e4698400bf6ea84496be43af50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ba8900fe6bccd784d2acf09f88ae0d070cdfa9ddfd2a87b5455cc16e6c19760"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-s -w -X main.version=v#{version}]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/goose"
  end

  test do
    output = shell_output("#{bin}/goose sqlite3 foo.db status create 2>&1", 1)
    assert_match "goose run: failed to collect migrations", output

    assert_match version.to_s, shell_output("#{bin}/goose --version")
  end
end
