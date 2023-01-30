class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.52.14.tar.gz"
  sha256 "a99398f442b104a62e34c31d0e4a59f5504a003d9a3f4d763d8ee0cbd083d232"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32efafd99344ce0999ee4add9a2b5f8b3cf2eaed28288e269634f9b0a5e1c046"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31699675cb0cc060a192ddfecafddff3a8e5ca47e95a93ba2e484db8550bbfe3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f5fed5e77976f90de876e66fc31c99e306f66fde939c1d3e45a14f037adc7fe"
    sha256 cellar: :any_skip_relocation, ventura:        "7a5ac1a382b81fa2e8f0753eece3cf61f1a7ca597f619eb443eb182bdf62439a"
    sha256 cellar: :any_skip_relocation, monterey:       "2dd597cbe5ca00aa6e7815873fe0fcbc53c3ffe4641c38e14251e55c4377385f"
    sha256 cellar: :any_skip_relocation, big_sur:        "25041c2ae53b23ebf4adc59735ced18708b0300133c6964f9ea63d0170921e69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f55c56862855cf03e862732680367619f9072e9b178ab5ce22ef71d7734dfca9"
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
