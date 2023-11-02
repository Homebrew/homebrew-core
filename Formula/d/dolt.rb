class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "fa26a91ee40fbce425264d483d59abeb0346697b46759e1206f134a9bccbf50b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1daab314d96bc333a30de75985fa285448e9d1dd1aaf4fc5170ce0c228253f09"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b799fd6c746dab01ba4d151e8aebd2621daf9d01d9066314b4acd1ccde0355a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4444dc120cc6b9a32d70646e7d8372f07ab0d6bf9ed94a1631af93609679086"
    sha256 cellar: :any_skip_relocation, sonoma:         "db690b8b19dc8860f12e7c294b22be4e11e2d7b18fad956c9c4eb09511fe5557"
    sha256 cellar: :any_skip_relocation, ventura:        "86f8c5b49f5f9ffd60e5f212fe5a5e01fa253015805d301d2e36b7b6f2c4f577"
    sha256 cellar: :any_skip_relocation, monterey:       "fd06ed17c8b700f79151d8b5f9183f21e1c9757d5d87bd1ace4970f9aaf811d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ec36b2e6904d9067f95d15bd245e5d6abe0dec327481372f2488279042e616c"
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
