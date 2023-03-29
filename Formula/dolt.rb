class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.75.9.tar.gz"
  sha256 "615e0946b97fd8a51f35e27198d33b32b2bd1c9d75b3c4cb4eeae5f27ccf0100"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f7bf4f238726b39e8ad6f3d9e53eec1b6cc5e72bbf457fc5d437653dca67391"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f7bf4f238726b39e8ad6f3d9e53eec1b6cc5e72bbf457fc5d437653dca67391"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f7bf4f238726b39e8ad6f3d9e53eec1b6cc5e72bbf457fc5d437653dca67391"
    sha256 cellar: :any_skip_relocation, ventura:        "965bee679f2da7aed90c535c7de692a26b33f7591f98ca277b2c6391e62843c1"
    sha256 cellar: :any_skip_relocation, monterey:       "965bee679f2da7aed90c535c7de692a26b33f7591f98ca277b2c6391e62843c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "965bee679f2da7aed90c535c7de692a26b33f7591f98ca277b2c6391e62843c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc02d9b02c00f554508ac4eda06750ea354fc9de71bf9e2ddb4755c32e377a96"
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
