class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/v0.51.4.tar.gz"
  sha256 "1a3c9ffc6c90cc99d9dbc881505e4b9a9b1e31d44832215b5331d8a4a933c90c"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25b78c663a84f72406d3b8e55b9d4d0244000cac055926b04ecc6322055f3d56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3bf73f02c9ad0ecde380b5a36574f343b4034f391c0a500f7fd0b92e1074be3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28a5c227a4b2944f0bdadb242be4e3b74505708466496105a62d88e54ba1456a"
    sha256 cellar: :any_skip_relocation, ventura:        "82b807d5520be66fbee3588674307001b3b0f87671e4aefaafd83e77075b94e9"
    sha256 cellar: :any_skip_relocation, monterey:       "07d82b7a442fae6f07ac11275458b523bc51575121449f65c8e66d0712965721"
    sha256 cellar: :any_skip_relocation, big_sur:        "724652af180d95f9f603894297e27b705138b400b0474f8063e0f5e2f1936940"
    sha256 cellar: :any_skip_relocation, catalina:       "8888b792deb630d5304cf343b558474b4c2c46655e03321b49c9b02329bd8bc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5295deb00ee5e5985154de88db0407c46a119178475ff019e23f37abc5bf275"
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
