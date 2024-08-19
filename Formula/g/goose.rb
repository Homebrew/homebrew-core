class Goose < Formula
  desc "Go Language's command-line interface for database migrations"
  homepage "https://pressly.github.io/goose/"
  url "https://github.com/pressly/goose/archive/refs/tags/v3.21.1.tar.gz"
  sha256 "f7c6b6c0a22c68dbe88025d56f8c05c4bbf947dbd9b73c26c641583ee0388e39"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c234f94292052969bd4a0f96ec356bf93ddca2e0371a47feb22953c9382b8826"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ff1f545eb1176beadcf8a1b21413015930ba18e5d071e02b9de7087b608a3ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5df331e7d99a33557e95cde3e7d89318db4ee294517ff1265bf50505d003ee29"
    sha256 cellar: :any_skip_relocation, sonoma:         "40ccd99de79b91979cb0a9d1542b8c76707eea54a2aff0e5d156906b9945f71d"
    sha256 cellar: :any_skip_relocation, ventura:        "44857de7a61d2134cafaeb50dab9a129b4f61d689b5e318bf3a95c8efb75a1f5"
    sha256 cellar: :any_skip_relocation, monterey:       "1f069d20c0151a52e518a7d32c5f5ad51d53d8d90e8bb8056c8ada1e2faaf9b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "445176c88789958ff0c71af2066a76ed341082636491482720cb8fa6edfbe7c0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-s -w -X main.version=v#{version}]
    system "go", "build", *std_go_args(ldflags:), "./cmd/goose"
  end

  test do
    output = shell_output("#{bin}/goose sqlite3 foo.db status create 2>&1", 1)
    assert_match "goose run: failed to collect migrations", output

    assert_match version.to_s, shell_output("#{bin}/goose --version")
  end
end
