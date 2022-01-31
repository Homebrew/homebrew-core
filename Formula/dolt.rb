class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.36.0.tar.gz"
  sha256 "f87f40b95267cc1032fcaf186657ec16cbcc524932418c6f9bfe5e2148c0ac53"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8706888c77213f92d123ec0d727499eab402026817e1287523af36bb7e9e51e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "850792d3f36067b5f65025d6e1c61323c529e4dc1a6ff3a2784e9f028e0fe5db"
    sha256 cellar: :any_skip_relocation, monterey:       "eee309e7a4db80946c124248cb9b6430f58fafda4d343479c2759a5145cf85fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "e3f3ba089bece38c8745b080d2757f910689aa86f87798b0abfabdbefd06a972"
    sha256 cellar: :any_skip_relocation, catalina:       "3bd2ce81d7da0e3789610a6326c3479a904a33045c022df449c363793ba9cbb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5645137a0ac8e2fb99e9572d78976309a2dfd7a3b105ca97ce47c1a19d6b51a3"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
      system "go", "build", *std_go_args(output: bin/"git-dolt"), "./cmd/git-dolt"
      system "go", "build", *std_go_args(output: bin/"git-dolt-smudge"), "./cmd/git-dolt-smudge"
    end
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end
