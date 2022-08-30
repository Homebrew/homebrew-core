class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.40.31.tar.gz"
  sha256 "8d89d9d332e33fc8b436200764a985aab509f4a6f26264dcccba26369aa3e2f9"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bacd5d207252af79e6f5157ea037f6694bfdc926550083f727235ff41c49394"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88aa4ccebef32ca0df2020f4609aa605cffdf0d2428adf5d17a269bb4c45d3e7"
    sha256 cellar: :any_skip_relocation, monterey:       "4e6174c6e44ecf6c859cf132a65c406030d64d0d6b35244d329d46192120b6ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "7f912363d0fac5568ce457d38f6b112521729b96e8431624f77a14679ebcac15"
    sha256 cellar: :any_skip_relocation, catalina:       "1ab88e8cff91c7b0de7bdeb882d4522e9b8449c8d060c83179fcb8ec63ea5034"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "535a28caaeb34fd9c0481db440b043d3bfa0b1d36fe9c2c8986d7f9ecf322d30"
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
