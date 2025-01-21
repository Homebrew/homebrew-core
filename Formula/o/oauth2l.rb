class Oauth2l < Formula
  desc "Simple CLI for interacting with Google oauth tokens"
  homepage "https://github.com/google/oauth2l"
  url "https://github.com/google/oauth2l/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "9de1aac07d58ad30cfeca4c358708cffa3fb38dfe98ce13abd984a4fd5e3b22a"
  license "Apache-2.0"
  head "https://github.com/google/oauth2l.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c49d407d6d17468a125133fea468f80d2467145cda60ea19f055f960c1cd0ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c49d407d6d17468a125133fea468f80d2467145cda60ea19f055f960c1cd0ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9c49d407d6d17468a125133fea468f80d2467145cda60ea19f055f960c1cd0ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "fca8caad48fba0df2fb5a48a02f0363fab2b971a513db426d34525904cd8d1f5"
    sha256 cellar: :any_skip_relocation, ventura:       "fca8caad48fba0df2fb5a48a02f0363fab2b971a513db426d34525904cd8d1f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "946b103ade638f33e8fef37733b89ceb14fe1fd5b6733465526720d7880891db"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Invalid Value", shell_output("#{bin}/oauth2l info abcd1234")
  end
end
