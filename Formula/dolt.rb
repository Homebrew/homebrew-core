class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.40.27.tar.gz"
  sha256 "e52652ece4e38b03883bd2182d74c129e2953c39055609c1752cb6efaf9bc330"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e4a63912abebe6d0045c5dc5db6de69deb51ba1378758895e865d768a9682c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95094b0ddc2c98c95df3818212c8af07fa8018150eb76c4829c3b99f9f8b48a6"
    sha256 cellar: :any_skip_relocation, monterey:       "51b903a368b3c8f4d3f044bacb99e7ac17a8c65740ad640206ca9f6badf57e35"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4ad1ee383cdee53783bc8dc71f132d461e11d28cce47da078d9a63755d696d2"
    sha256 cellar: :any_skip_relocation, catalina:       "ad6392457f157aefa994c68b9c4f401d6e8506fe123433b9cee4da191bb42503"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac4d683df929ce85e60df44e85a63a61f4e8ca5d83b17d7ad9c4700befba88ec"
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
