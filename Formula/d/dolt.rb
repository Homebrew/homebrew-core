class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.35.2.tar.gz"
  sha256 "904afc428914172f812ee123f0b3ff7857133b8a22cfc212f73e40c88ac5e829"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1423bcd39ae8ce9f271ecb62961a1d1e41869694f9768fe9ccab70a0db4d1816"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2828efb36076f2b0cacaa26236fcb192a4a639e110e077b8e5f8e10fde636469"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f54ce97a76fb411d0b6946df4071efc1eb5acd9af114818e11f7c35a1beb15b"
    sha256 cellar: :any_skip_relocation, sonoma:         "5487c63fac38b9f0d62bcce3a3e76c50dfbdd909999b9db4011e82fb12755e62"
    sha256 cellar: :any_skip_relocation, ventura:        "d9855fcfb6d6ce080953a11fd834f73e8f4b881e694322b288e2d04d3c3abec7"
    sha256 cellar: :any_skip_relocation, monterey:       "4d010174bffecb63d4864334cb3bd94739e83601e86ee7a1c704253e4521151c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4e96b532a989e568ca0fadaffceb2ec115d152a2f74f3f2a62474f49fa6121c"
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
