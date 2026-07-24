class Jjui < Formula
  desc "TUI for interacting with the Jujutsu version control system"
  homepage "https://idursun.github.io/jjui/"
  url "https://github.com/idursun/jjui/archive/refs/tags/v0.10.9.tar.gz"
  sha256 "1e6f74b3e00bb652f533331a15e4e0b9d6139a0db6f3f0f1e5b348ce547f72d0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c595c9c6072bc509d11062c646a392d197dc6d649b5a9f7750db8ad7de447be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c595c9c6072bc509d11062c646a392d197dc6d649b5a9f7750db8ad7de447be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c595c9c6072bc509d11062c646a392d197dc6d649b5a9f7750db8ad7de447be"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5eea2bef34e21cbe8359381cb0be1c051265f0f1d3dd70699bfca37f4c83c00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa8dd5e073aa704cdd28d4c796c0468070a820e440ee27c312388867af25dfd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fb5226259f82c8b4063c0c8760809be166258ba755c045fb72815a3d9fd1718"
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
