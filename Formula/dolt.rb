class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.50.5.tar.gz"
  sha256 "0efd0f6358560146fac059db97a091ef28f01b1a8ab6bd0304af05ed045355b5"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ffe62a028a6bd873ccf9d44d21dd4644407f7c42d4c50630fda7b193568119a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0dd515a3165e4ee8397356ca68a2d78da2295b9237f21f3748e72c97372a1c30"
    sha256 cellar: :any_skip_relocation, monterey:       "6ab97f0c8f4c58bc3a6e4538149685e9d00caa0c01503b21b42ab20f39c37afb"
    sha256 cellar: :any_skip_relocation, big_sur:        "dfd6be56f4ce33652ae68a079c567c2ee1be4565fde3d711ddfbe652f628de45"
    sha256 cellar: :any_skip_relocation, catalina:       "21ee3f3f9c5025fb348d3e65fb3c28ecf90a93512eb0d48a7c6c931445ce92ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b5e4eaf0d6f7286c7a29871d7091c7a62aa51d71aa5b5f6e47d3e21ea0a77a0"
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
