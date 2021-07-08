class Gitql < Formula
  desc "Git query language"
  homepage "https://github.com/filhodanuvem/gitql"
  url "https://github.com/filhodanuvem/gitql/archive/v2.3.0.tar.gz"
  sha256 "e1866471dd3fc5d52fd18af5df489a25dca1168bf2517db2ee8fb976eee1e78a"
  license "MIT"
  head "https://github.com/filhodanuvem/gitql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7696c9876a12e665f0f7915a80ce514e5961dc79d6145ec0d45386da47c4193f"
    sha256 cellar: :any_skip_relocation, big_sur:       "07a4599ecd1fc45a843b0b4b0e4ec417ee2815417ca89641c7a04f34ba95e7b6"
    sha256 cellar: :any_skip_relocation, catalina:      "f335da354c07c2bc904f7646cff64fd1b4dcf4efaf71f1d4c41b0dc956dead1a"
    sha256 cellar: :any_skip_relocation, mojave:        "f8dc93d9074d600de7be7afe5ac9e9947824bdda18eab6fdda87ba1455fa6488"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb1b0e2266de96e0eb1e27459b83158e39b8fe0c3620f4cbc49149f192b455ae"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "A U Thor"
    system "git", "config", "user.email", "author@example.com"
    (testpath/"README").write "test"
    system "git", "add", "README"
    system "git", "commit", "-m", "Initial commit"
    assert_match "Initial commit", shell_output("#{bin}/gitql 'SELECT * FROM commits'")
  end
end
