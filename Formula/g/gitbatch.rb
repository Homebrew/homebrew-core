class Gitbatch < Formula
  desc "Manage your git repositories in one place"
  homepage "https://github.com/isacikgoz/gitbatch"
  url "https://github.com/isacikgoz/gitbatch/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "0ef36a4ea0b6cf4beb51928dd51281ec106006ba800c439d2588515c1bfeaf41"
  license "MIT"
  head "https://github.com/isacikgoz/gitbatch.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "4f0dfe4d2f87530d4b6efa9896233606294804a6ec6ae6acd783e7a0fb81bc0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0a46587ffb66c2c071a4052ee70f81ddd41b93151e09b19404f789b5fe9f1b1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f02f2110548020dc68f4086aa3590791ca4366a8bb8f14a6e2641b71d226b0d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ae6361b3bc790e3b226978f4a841f3dbae69050e0214ad1ee6d30a383249a42"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "019454b03cd4d76a4fd4921b211dd74a1ac5d21263e5c81119b02fc56b4de151"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6870e51c395a0c2bb7da37785ddd6932d18dd516905d0ab5c02632015edb39c"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b84d60a26974b8f1f6e1d31fe360f09d6a04d01a6f6d2425291d5a027f83fe1"
    sha256 cellar: :any_skip_relocation, ventura:        "00104e93f6610498cccea2112338f3f9fa516ca3bdf66ead50640e9d97739b8b"
    sha256 cellar: :any_skip_relocation, monterey:       "f79aa114971d190366dc81c1bc6deda1c176c74a33e0abc3a89875c4785414f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ae2045b1f348f381d15ff6eb708ac5ace0f550c733f3f5002c5edde50514c08"
    sha256 cellar: :any_skip_relocation, catalina:       "6ea0a1220269223eb0ffb99eda340f726a146dafe10b8e558e44eea278d15a37"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "cece7a9bb8193efdc4aee9d9f44f49b979b88a93b2a120bc247125d90f3276ea"
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
