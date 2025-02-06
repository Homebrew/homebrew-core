class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.49.0.tar.gz"
  sha256 "e4232319cff900cf21fb51d8d08afdb28303cab5b27d75d850188d193fd9a50e"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f40efae96264e3c95f3ab908c84341a20490da2457f8deec5769ae7d31ebc1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f191c4ea886925b84f406d5435f9024d63ce6d9cdc2df2bcb7a0151282243a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f09a762520bc735dd2ffeee66b2a5c3b0468f291470946eac15557a310eb6c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "48c0b3b57acbfed397abd9a796107bafaea22610543404103c627804a78883e2"
    sha256 cellar: :any_skip_relocation, ventura:       "24c29f115feb602fe84ed1d60f0248ac89a0e95d6f344075acc6b2bc42099faa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e0e5268e7dc12c24f8c5ed8631bc57e00bf0a68cab13467981723c30103f907"
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
