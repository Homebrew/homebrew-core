class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.52.10.tar.gz"
  sha256 "709e0d3d890e3e21007a5fc7d7ef22df73fa48f842d579e82a3dee8d3fdda15d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "904fe0627b19631459fe8624b18c9fdef7e74df4865f58e66defa380b71e3bef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d22a197443ee19898580625ed27d23f8d245b72105909b7768268512d1b08d7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d3380456bace3d2db696e30106f091f9b45db12d8253871d857d28345b3274f"
    sha256 cellar: :any_skip_relocation, ventura:        "16e3570c3df399bd6fcf66e2452369b14e6f47428427692de49fc2c6b83dd404"
    sha256 cellar: :any_skip_relocation, monterey:       "4aecebddf2b8762eccb3dc3c0ac9eee5664fec39bd9950f2b54ffda3304a450f"
    sha256 cellar: :any_skip_relocation, big_sur:        "0665f068840e2986943e801501a31c70ad95e238691984d622749eb256ee15b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7271c757cfab7cd289e6303c641772c02cd7db9b5c9c46cf609b9abef4744e33"
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
