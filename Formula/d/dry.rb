class Dry < Formula
  desc "Terminal application to manage Docker and Docker Swarm"
  homepage "https://moncho.github.io/dry/"
  url "https://github.com/moncho/dry/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "636d6b371bf329443849d19d574e8b493d77528d18167b52381df12755ba2ae7"
  license "MIT"
  head "https://github.com/moncho/dry.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ad59335cbcad844568a7115a7f12f1b298fba6658cb1eadde84cc4a1edd5493"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ad59335cbcad844568a7115a7f12f1b298fba6658cb1eadde84cc4a1edd5493"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ad59335cbcad844568a7115a7f12f1b298fba6658cb1eadde84cc4a1edd5493"
    sha256 cellar: :any_skip_relocation, sonoma:        "526cd8d533f8bc402361b0232210f6c55e6958908ebdbfc55eaefc46df8b6954"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11651faa99235c2f62844b03297422567a16b424b4cc0cefc05a65c53abaf0c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3ab2319477e1cf89cee244f6add99a3f5054399ac4681cf25a5a21eca43b103"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/moncho/dry/version.VERSION=#{version}
      -X github.com/moncho/dry/version.GITCOMMIT=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dry --version")
    assert_match "A tool to interact with a Docker Daemon from the terminal", shell_output("#{bin}/dry --description")
  end
end
