class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https://github.com/ariga/atlas/issues/1090#issuecomment-1225258408
  url "https://github.com/ariga/atlas/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "9392032e69b3b811eedb22f4d34d9c7e027c872a61e5b05db71d4e84ca27a04e"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e87ab6cc275649728f4a987d85d490952157fe94bd9bdf2e0e1dfc360dbb12a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "082e062bf3edd405c910da6b20d71c8cb5c157b3976fceb835b05d68e7010de6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dcbc0753ba82e1b391998244ddd9c50b4c727c6bc1d2e5c9165c6875c2584ace"
    sha256 cellar: :any_skip_relocation, sonoma:         "2555ccc964966ffb9d384fd4f0808bc840f385373e47b803ca57cbf77baa4ab6"
    sha256 cellar: :any_skip_relocation, ventura:        "68b71fdbac3038a9605b5ef13648c8c7d61049c25b0318f1aa78db9a79e0e518"
    sha256 cellar: :any_skip_relocation, monterey:       "7744732d62798fec1fade3f7e48de2f730b8a0def90f82b73b0e7b1820298eaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c49f3905c8c682fa5fbe44e3aa0e197150acadcdb26396d221cb673cc0b8454"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v#{version}
    ]
    cd "./cmd/atlas" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    generate_completions_from_executable(bin/"atlas", "completion")
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -u \"mysql://user:pass@localhost:3306/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end
