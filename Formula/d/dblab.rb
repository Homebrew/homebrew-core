class Dblab < Formula
  desc "Database client every command-line junkie deserves"
  homepage "https://dblab.danvergara.com/"
  url "https://github.com/danvergara/dblab/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "7e17c863b3ff1e01bbedbbc421af84fada146648e162d129eaabf9e85485a47d"
  license "MIT"
  head "https://github.com/danvergara/dblab.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20dffdc520ad78c8e9646504ab62728551c7e6e90271fe949f2ce3910d26acbe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3047aa1563b100da84c1b2526f3bdfebad492d585f6b93e0948ba5ae58d7d7ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9fa9d07b585ca8eaf2d01b9090894561d13b2d04c7dcf8f4431da91f468e567d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4de556ff71bc799425eff6e8cb5fa31d43b69846d25b306e1b5fadfbcd68e76"
    sha256 cellar: :any_skip_relocation, ventura:       "507440d4bca59b692fd97bba4c56b275fd904ef17bf834c7395ca5f966e4ee39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "140f175c8ce2e0be529b37fd7537ea578dee6e943ee3a5a769077038fe30c353"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a206dfeb89f7082430c9f5b46fe5c921b8dc7510091f0db44f096f921188dab0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    generate_completions_from_executable(bin/"dblab", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dblab --version")

    output = shell_output("#{bin}/dblab --url mysql://user:password@tcp\\(localhost:3306\\)/db 2>&1", 1)
    assert_match "connect: connection refused", output
  end
end
