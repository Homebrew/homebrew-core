class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.75.7.tar.gz"
  sha256 "349b20f34f8a354fd23aa58743f5d9db6000be3b203d6c7d93640becf3d67f39"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ea707db49e62af0045b4f11340dec20f40f9f8cfec7e6b3b35b64ed2f0e7893"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ea707db49e62af0045b4f11340dec20f40f9f8cfec7e6b3b35b64ed2f0e7893"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ea707db49e62af0045b4f11340dec20f40f9f8cfec7e6b3b35b64ed2f0e7893"
    sha256 cellar: :any_skip_relocation, ventura:        "f97e0579c147495d7f2f2b49db2ab3e43be9c037c1761a376845e09ff3651959"
    sha256 cellar: :any_skip_relocation, monterey:       "f97e0579c147495d7f2f2b49db2ab3e43be9c037c1761a376845e09ff3651959"
    sha256 cellar: :any_skip_relocation, big_sur:        "f97e0579c147495d7f2f2b49db2ab3e43be9c037c1761a376845e09ff3651959"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96b768c31a5f2f85c498d2b79bb7c701c61bf0f04525f0f88b636152e312b6f6"
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
