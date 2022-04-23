class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.39.2.tar.gz"
  sha256 "0842adf7d6cbb3ae0ce1181c7c63680ea20b89a1656fdd689ac7a59eae64546e"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85ed0657484aee8352dd007b58e833a8c89f9fb67bbc325801d267e05f22cbc0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29adf048ff7cde2647ae06eb5039b6c2b78335bd56e841a4504fd371f6f1c195"
    sha256 cellar: :any_skip_relocation, monterey:       "9589b2d5744df52d58e415527c3923106283e49bfd7d2399f3ad8da1cd1be963"
    sha256 cellar: :any_skip_relocation, big_sur:        "d97856280645e2a4c512ca1c749aad9958133205545bd4ba3167169f93ceccf6"
    sha256 cellar: :any_skip_relocation, catalina:       "48c1215426f50047eef471fc88501c909317aadf6ae835fd9a7f839a637e4ff3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e5bc3e457df7f9a398e456b636453dd02535b4b6520a1d30b41acab51775f52"
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
