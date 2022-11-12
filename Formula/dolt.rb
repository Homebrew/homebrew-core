class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.50.16.tar.gz"
  sha256 "fd48e92d046d78e3d9687e145d885b18c5c2217803a806dc7260329ca23e7cd0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64ff696db1ef14d7e88faf8d89fb87a9527615129a7ce46c775bcfec0e7afc58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "939a93be35f0afcc02bceac74380220a8feb0cb49d41f283af57db4da4ae1963"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1824c597175d9e027711da31dd64cbb0d93ce2d6841ea89118b93dc00870bcad"
    sha256 cellar: :any_skip_relocation, monterey:       "1486b2b719795ed124fc7dc4b8ee9b004a17890e7ff44c938fa21b38bbb69b53"
    sha256 cellar: :any_skip_relocation, big_sur:        "7535ca9dccfca369a3dff77e5bff0b1d417db28277602eac5936a99a905f6f37"
    sha256 cellar: :any_skip_relocation, catalina:       "1395ce2c3895273b4e6804b0db15b70eee1f065d972974d4f85b7c5ddb467321"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "591c0ed8851170eae8896f5b61f07867bbee24fbf08aa4f0282f3b791bc4c576"
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
