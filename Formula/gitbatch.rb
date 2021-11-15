class Gitbatch < Formula
  desc "Manage your git repositories in one place"
  homepage "https://github.com/isacikgoz/gitbatch"
  url "https://github.com/isacikgoz/gitbatch/archive/v0.6.1.tar.gz"
  sha256 "0ef36a4ea0b6cf4beb51928dd51281ec106006ba800c439d2588515c1bfeaf41"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "019454b03cd4d76a4fd4921b211dd74a1ac5d21263e5c81119b02fc56b4de151"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6870e51c395a0c2bb7da37785ddd6932d18dd516905d0ab5c02632015edb39c"
    sha256 cellar: :any_skip_relocation, monterey:       "f79aa114971d190366dc81c1bc6deda1c176c74a33e0abc3a89875c4785414f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ae2045b1f348f381d15ff6eb708ac5ace0f550c733f3f5002c5edde50514c08"
    sha256 cellar: :any_skip_relocation, catalina:       "6ea0a1220269223eb0ffb99eda340f726a146dafe10b8e558e44eea278d15a37"
    sha256 cellar: :any_skip_relocation, mojave:         "35e4351bc3abfae50c14c8d32f0fdfd756259c77246d19720f9178a20a79ad1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d447c8dc2e642b6a281df3956224ece3f45cd0f074391b8dfa9f916cf5e7dcb"
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
