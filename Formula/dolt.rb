class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.54.1.tar.gz"
  sha256 "3e8ab05dbbba162fd707f6f747772dc5128d92249a9c9183371a6d0ce1565efc"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c67e361e497afffff0b420ccec8d3de9431ebc6014af402fa3d094a4a195da1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c67e361e497afffff0b420ccec8d3de9431ebc6014af402fa3d094a4a195da1b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c67e361e497afffff0b420ccec8d3de9431ebc6014af402fa3d094a4a195da1b"
    sha256 cellar: :any_skip_relocation, ventura:        "b4d0b61fb033054fc3a96c1758540445a0dbd5ecaea4c04e021268e20b577341"
    sha256 cellar: :any_skip_relocation, monterey:       "b4d0b61fb033054fc3a96c1758540445a0dbd5ecaea4c04e021268e20b577341"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4d0b61fb033054fc3a96c1758540445a0dbd5ecaea4c04e021268e20b577341"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "656f7b7f6470b44e88a175f7ca3f4002c13e83b61e4efe160553324b1f515bd6"
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
