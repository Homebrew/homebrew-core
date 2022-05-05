class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.40.0.tar.gz"
  sha256 "7e9fa4ba35f312c7c8718c029ea8dc3a65c5a4c1df01995db2eb48f48768d7a1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7844a1f2cc1bf0c3446d65c1c4906eefdbd70fbb3eedc092117d99bdc68ee724"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10951cf76c47a43c06398dc135acd7b794fe2193ecdf67c0e0b1a739b33f7096"
    sha256 cellar: :any_skip_relocation, monterey:       "82b5c4a1332f310da3f97a8ac4d106c9ff1a1f73221929a00c78f8a0c474e300"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b64b47a6f2b03557423a637e6e175c39903cf1294785ec8a9f2f0af2b7646a2"
    sha256 cellar: :any_skip_relocation, catalina:       "6cd468c7d82d203f95bc0649c2c2fe2dc3d657e1607760d521a805552ca16edf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3079f85e17afe0c6f9b72e5b26d899b3de308d3122dd86442eaae96b02fae676"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
      system "go", "build", *std_go_args(output: bin/"git-dolt"), "./cmd/git-dolt"
      system "go", "build", *std_go_args(output: bin/"git-dolt-smudge"), "./cmd/git-dolt-smudge"
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
