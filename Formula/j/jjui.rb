class Jjui < Formula
  desc "TUI for interacting with the Jujutsu version control system"
  homepage "https://github.com/idursun/jjui"
  url "https://github.com/idursun/jjui/archive/refs/tags/v0.10.5.tar.gz"
  sha256 "0369e07b2aaf52a05d32bb11479fdf314aff19e41d6ebc8facb83340ebc4e2bc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99290951d6a72395be5ee9f4aeebb38783ce38d3d7e1bf2b3f02448409ff09ef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99290951d6a72395be5ee9f4aeebb38783ce38d3d7e1bf2b3f02448409ff09ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99290951d6a72395be5ee9f4aeebb38783ce38d3d7e1bf2b3f02448409ff09ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "98a04cb9ab89f8b9901c4013471f0b66db890a5186304fe030a38d15d715702b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27aa083853c4eff7f32ebc731e17440d330bdcd571e376a33a274b09b6ea03ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23b6922bcc00fe3475b57ac3f8c00627454cf59232d95c268565ed92669c6a82"
  end

  depends_on "go" => :build
  depends_on "jj"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/jjui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jjui -version")
    assert_match "There is no jj repo in", shell_output("#{bin}/jjui 2>&1", 1)
  end
end
