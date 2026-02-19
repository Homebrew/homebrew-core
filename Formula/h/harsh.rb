class Harsh < Formula
  desc "Habit tracking for geeks"
  homepage "https://github.com/wakatara/harsh"
  url "https://github.com/wakatara/harsh/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "e675b1c8d3d125842baba51d1d9b29af9919bf44b1fe355f8b406d4af4971778"
  license "MIT"
  head "https://github.com/wakatara/harsh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6152de594618ec56b286f20d48e8be019bdf116687902e5c34bf7f519f9012c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6152de594618ec56b286f20d48e8be019bdf116687902e5c34bf7f519f9012c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6152de594618ec56b286f20d48e8be019bdf116687902e5c34bf7f519f9012c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc75639ee67215db7f0fb512228f5a259cb597750c1744c8ec623be792357073"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8be1ad853f18cf79ee60787bada2cc35129e57b1b87a1a1b7ee60befd13af32d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "665303c51ba002e908df569efbd011776cef4ddab8cf93cbc4bec9015e75166b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/wakatara/harsh/cmd.version=#{version}")
    generate_completions_from_executable(bin/"harsh", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Welcome to harsh!", shell_output("#{bin}/harsh todo")
    assert_match version.to_s, shell_output("#{bin}/harsh --version")
  end
end
