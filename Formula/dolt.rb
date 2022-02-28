class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.37.2.tar.gz"
  sha256 "4ac142a940ebd7bd31e020d398ba7053e08bf0aaf2a0eedb3e3f6d54d94ff365"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e780201942b15ec72462b7ae8f2a8a7c0abe12e81baf7a9bc651d21929aa6af5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7335805fe5186db8af3c7e98d47f0c600c2d1eac4d0b62e5f47feff8dc15ca4"
    sha256 cellar: :any_skip_relocation, monterey:       "339ad2e5ccc504473bb74152d0598115a1e33c8c6237bbfd34bcea13f14fbe93"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c9970194bb51775df644d6022e4c0a1b67db2b9c40db0701ab816fbb4add55f"
    sha256 cellar: :any_skip_relocation, catalina:       "2542c4dc01f7060fc8562d7367407149c2a95fd5fe1380faaeb9c3b7c3f6a76f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2b624f7d6efab7a5aaafcb188f49128115d960cae0dd9351adc6bec8c653de0"
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
