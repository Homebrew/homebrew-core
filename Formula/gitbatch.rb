class Gitbatch < Formula
  desc "Manage your git repositories in one place"
  homepage "https://github.com/isacikgoz/gitbatch"
  url "https://github.com/isacikgoz/gitbatch/archive/v0.6.1.tar.gz"
  sha256 "0ef36a4ea0b6cf4beb51928dd51281ec106006ba800c439d2588515c1bfeaf41"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "435b26ee9b78a811d918ef891a9e57570179c4a543095cd83c86e02d017787af"
    sha256 cellar: :any_skip_relocation, big_sur:       "f9e66be24dac6acb5c3bb771971ac7d8736002a51b400a5922d9e99a33868d75"
    sha256 cellar: :any_skip_relocation, catalina:      "725d490cf957518eb5e169564c77a044cb48ec64c40bf1003ff859fef9461b16"
    sha256 cellar: :any_skip_relocation, mojave:        "4fbdaf04019dc3fc925754a6401b17793aab30860227123f8df17aaa114fa531"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gitbatch"
  end

  test do
    mkdir testpath/"repo" do
      system "git", "init"
    end
    assert_match "1 repositories finished", shell_output("#{bin}/gitbatch -q")
  end
end
