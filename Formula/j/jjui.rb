class Jjui < Formula
  desc "TUI for interacting with the Jujutsu version control system"
  homepage "https://github.com/idursun/jjui"
  url "https://github.com/idursun/jjui/archive/refs/tags/v0.9.10.tar.gz"
  sha256 "cb963c4489e72b881cb43d2196bcbb92f3dc7bb74d488cf3c403d9193967189f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d6c5533693c52c4bdcba7b38f8aaddfb1e0b35a1ae940102e4a3c298a864f5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d6c5533693c52c4bdcba7b38f8aaddfb1e0b35a1ae940102e4a3c298a864f5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d6c5533693c52c4bdcba7b38f8aaddfb1e0b35a1ae940102e4a3c298a864f5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b883d6171b292f7f5741955b8ad2336be40d5a2f7833f61495071e1a587d84f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d2af1eb02057f28006f8a950129de6d7accd090c6c69161f7e6d415ca038f07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "078467b83a4030ad545a8a905c121655df443c00efc63b3053c2c491e038c3db"
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
