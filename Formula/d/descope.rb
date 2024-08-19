class Descope < Formula
  desc "Command-line utility for performing common tasks on Descope projects"
  homepage "https://www.descope.com"
  url "https://github.com/descope/descopecli/archive/refs/tags/v0.8.7.tar.gz"
  sha256 "25c1b805aae8100a1f9763f16a25fcbbc9449fe32534d356b58f88e17b305fe4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d641d2ff15afc45fab9fc4c569ab4e6af149679b45e6c94cd9c7596b2dc544fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb43c4cb24a1e9f21ced3a7670568d10eaab435a2ca2ffedffd5224cd842ff4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e12cc3ae137d4bbd6e1267d17308e37395993922d16c927206a795237846544"
    sha256 cellar: :any_skip_relocation, sonoma:         "c64a6389d07cbee936b212ec4f72b0f9e998cf8a79785d0cfa8bc12fc081ef2f"
    sha256 cellar: :any_skip_relocation, ventura:        "277b49dd92dce31d9a8714854f3a3227784eb85da4eed092dadafa2d021e0186"
    sha256 cellar: :any_skip_relocation, monterey:       "ac5107007baa10d1157163862ee7cdcc97a8cc7fe08f902359a142eb8def213e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e25ac2899a0a97528fdf1aaab2fa3170362cd5fd0f7f318c01825fbc1f6594e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"descope", "completion")
  end

  test do
    assert_match "working with audit logs", shell_output("#{bin}/descope audit")
    assert_match "managing projects", shell_output("#{bin}/descope project")
    assert_match version.to_s, shell_output("#{bin}/descope --version")
  end
end
