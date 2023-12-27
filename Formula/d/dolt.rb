class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "398a286ec6d302156b4463137ceb1a729a62245c7e79f74d08f83a722948a113"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "33e19eaa4bf4bfd4ec537d4bacec9df57c26eade3c1535da51409f4c0813af55"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7cb9fd9a3788b4daf91699c31a2393789952cbdb9a013b28e96d7e2a84767733"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56edea79b6e3fa052a9347350c91e6a108fe4ed74d02fdb8f942e86f90b46163"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e895789f24e929bd28c7754865926a058e27b60bc44fe67d0af844dabd9134a"
    sha256 cellar: :any_skip_relocation, ventura:        "8e5ccef99bd692c42df56f09e48fa226a89552e00683997e070dd900e920b691"
    sha256 cellar: :any_skip_relocation, monterey:       "383ad68ca273eba66af93a83d312eb13139c42d1fb83e74c837ea7b6390eb94e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d54595e5e463c2c2f9ec50abe5f3cc393bcaf2cddce30fea83eda27288926ca"
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
