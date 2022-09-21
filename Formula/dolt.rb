class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.41.5.tar.gz"
  sha256 "c2a5d154ad738f3d0a597db4ccd426c7ae69274fa058db9771ad425ca649093e"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a23eceab8e92e2add80e53c34843af6db625191dcd957337a7544de6caf1f23"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e2b1348e847411fdc898ca1ff0fcd718a56aebd3588326eeb39f6cc0c8b40f3"
    sha256 cellar: :any_skip_relocation, monterey:       "119310870f07d944f1061508275d9b0ffe69011c82e8e076b2aa2b087b7ed90d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4470162c9c41d8c8ae601420c1d2a8490b6a514fad9f816355f276cee37e6a40"
    sha256 cellar: :any_skip_relocation, catalina:       "085c5a28f6a25a28af364f1a13b91c47f4c61ca73fe975a525cf90d5a025008a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ae360d12d2e424e2a72714be1b855603e6073a1b9fe5daaf22570c06c963cc4"
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
