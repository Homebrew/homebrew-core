class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.35.3.tar.gz"
  sha256 "2a8e4795aa4932cbfd390b1c5d7d64adbc9d812b347b310fde1bfb266cdbd292"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c15a71974e854c36c422fa3c55709fa8233d25248d840cb17fcd40e3d2ee807"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "42db346123bcefa8d1c3e24a10faf4cb06630e53f1324cbbdb20cc5f3946b074"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f809e32ffbf7dc68236438eb77dd6f59487b17a0ddc6e353911fcd4fb9b87258"
    sha256 cellar: :any_skip_relocation, sonoma:         "8e76c68ee1787c7660ed3abe20b9e1e8b0360c2aa84ca11c652017042d89647b"
    sha256 cellar: :any_skip_relocation, ventura:        "39982ed020f3e988357a1d8d922fec8351acfe50078546aa006d7cd88405c794"
    sha256 cellar: :any_skip_relocation, monterey:       "a2135123f419d42be0ffb5ab64d446f2deb4c9bb8fb9b2f6a597eb9bbf2a3d61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9300788064b91ab7c592c16b95d0c38180968f2fe7566124f6ceffa3c1ac90cf"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"
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
