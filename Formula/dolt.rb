class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.52.1.tar.gz"
  sha256 "26f6cc3bf6cb2c6b06996d50e62e0cecb4f31d658e988f98ef63d670e530d676"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf449bdc8917e62b05cc5e7551712f413a868b14f9bf4d8129b0707ab82035e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f09c8873f8130d4f580d31c0dc0c44067865634de7419a269fa534d4617dfe6c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0066783bfbeff14526351ebb28f26d8b620b2dabe8bde10382520f466f7e2427"
    sha256 cellar: :any_skip_relocation, ventura:        "ec4e2723b0b1babfec6f30c57aac8570bd44870d95130a29d35fc3ae133b3355"
    sha256 cellar: :any_skip_relocation, monterey:       "83246ef5fd6967593ce423f2bf3addd6b209da681420ff7f30429b64f304bd50"
    sha256 cellar: :any_skip_relocation, big_sur:        "0691afd15769c5821ab1d7ceb7c436ca09a818615b9f85695fbb546c06e99698"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c11d7d28abbd210e1265cfd99769abc0fb74e8a9db6030029ffc574201bcd7bf"
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
