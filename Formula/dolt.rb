class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.50.12.tar.gz"
  sha256 "38bc826569ff2ad775336310b2f59ae07ef2b393df18f83c7e3255e2c45a858f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "957cc52f0fc69a09b7331488f702da114cb8f328a17b7c05bf2b9319e5f3aedd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a63c881ebf2bc5ee823682836546efbe5e43247c0ae383af015e3607e7191bc8"
    sha256 cellar: :any_skip_relocation, monterey:       "b821a4e266aa1300b857930ad2aa018353add894931cb5c11d3657ea92ecb592"
    sha256 cellar: :any_skip_relocation, big_sur:        "4487575b1a91fffc879034f1dd0b19803de82f4df22b633e38fa961bcf10145f"
    sha256 cellar: :any_skip_relocation, catalina:       "6b0f651b897fba5844390e4b6815aa7502e71103f9aca3a831a14ca1e74961e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "741a0ee9f3cd643140f029861ac4ea3b98336cdf404395770e4145a5d79ce4bf"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
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
