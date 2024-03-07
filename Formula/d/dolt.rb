class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.35.1.tar.gz"
  sha256 "c14d03154442690167eb06332cee1edf2dae99c191115bc30838f697078387cb"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a199383865fdf9e6565872bcd4bb4441808a7f586d31ef20cbc895d8b7355cb5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3e1a5ee3f2bd9f59064ba07bc69131840c3e08e4f0b98e0cc380a375bd7c047"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aabc73452a2672b51b3c81ca3ae69fded5e1eb954f15bc2d676663c75ee1e4aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "782b90e46cee3c7eb77893d95b9da3a813c953adf2d2e15bcce9ec66a4d5eba3"
    sha256 cellar: :any_skip_relocation, ventura:        "5db2605ce1d8079897950616d48b8a317881901238eb51657915adb0f02a4d6f"
    sha256 cellar: :any_skip_relocation, monterey:       "cccc92cf011b6cd9defb0e474d14f13e884634abac2ce4ddd5f3f9f1ecd67f44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "345215f6a1fe548937fb6c5d23b8f6982478c18ad0c9b53d4ae39a76d708c063"
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
