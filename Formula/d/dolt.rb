class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.43.7.tar.gz"
  sha256 "2542de5f5f41252cb07fa63e5947d8f077d00eba3067a3476489f6e789a994fe"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bb20cb70fe04f8eecd2040aac1cfa72a93795598090de1f34505d3f1326ada9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ef56b422907e37858a8748196e2f98acb4bb97846331f050d2df06ef389a605"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b6e2dc670f9a07d6e6307396af48cc92517d41987dd3c6e68b1ec84bd17f6a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "44e6bfc76e14eef349e8f7e06e73e799a8228cb09fad0943421abcae71a7649c"
    sha256 cellar: :any_skip_relocation, ventura:       "02ff11bcf7bf0b030fb0b6e073ac95a193f314bc5f3eca7face55d36fd273e07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "244e19453bb597ec60e35098939b6de3623d8f21c5108d68c67605dbffcd2a3a"
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
