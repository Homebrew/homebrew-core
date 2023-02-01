class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.52.18.tar.gz"
  sha256 "f59ee050b61251f6948a6fc271a1b0117ada7c119b5bf17574afac3b5e8f4ac3"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb03419e7a5447135c23fbbd5a77c8014805c4537b4797160cb54520dae9a093"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9d85c00a558e131dc3e7241ec1d7fd1debb927596fe3e09bce28c2bf6322562"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbbe777a29df8515c91d038b076777a6916ac32f7c7e20e6abc33cac381616dc"
    sha256 cellar: :any_skip_relocation, ventura:        "7f934686c406a9b0a71e1853861a2ed31b482ca2dab5abfafff0b40c5d1aee71"
    sha256 cellar: :any_skip_relocation, monterey:       "5cdbc691f9f88f45f77649850e99c6a29c72afc7f7e9e0f94cec1e0cc47e255d"
    sha256 cellar: :any_skip_relocation, big_sur:        "56eb27f31f34e16249a64a8fef3554c090b684f4a29262f64f68ef8e20f2da6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1a033b58d92fe67f45680f8179b2fe3aabb5a53ec07892def455110100a1115"
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
