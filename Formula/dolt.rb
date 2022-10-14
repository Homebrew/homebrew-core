class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.50.4.tar.gz"
  sha256 "ffa9e9c2e6cb2cae663416365e812019896b693c28b5a4adb11935f6e78cb4b3"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36bbb78ee748242a4b432ada57c04678835e910c1605246d7f96fa09ff5cd4ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4be7410bb983d187cb83e93aba38d36fda9f310f05f92e2b7aae3b4ee1d3e75a"
    sha256 cellar: :any_skip_relocation, monterey:       "7f3e7936c0d36121e320608349699bca73b472b644d031abe1678bdc13b556bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "a2d6762b067c42125eb026926a21bbeae01dd7cbccdf3238f1929a795e4621bf"
    sha256 cellar: :any_skip_relocation, catalina:       "c8407b0b5172b9fb30b44f04b7af3cc08d13c74dcd567639d1e82f7492525dce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8341014545d0e1b4415c0c55d6d47b8cb96d04e0f53bddfa7ca78f6eb46d12d"
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
