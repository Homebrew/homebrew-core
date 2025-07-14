class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https://github.com/jesseduffield/lazygit/"
  url "https://github.com/jesseduffield/lazygit/archive/refs/tags/v0.53.0.tar.gz"
  sha256 "c160053ae99cb741c6d4295d52f917e492168b204780f9ad1afe8f984c6604a6"
  license "MIT"
  head "https://github.com/jesseduffield/lazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51ddcbae258d86b10cf7782da92e85db4062f960e1c7d215b2c2f9d9b0e6bc80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51ddcbae258d86b10cf7782da92e85db4062f960e1c7d215b2c2f9d9b0e6bc80"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "51ddcbae258d86b10cf7782da92e85db4062f960e1c7d215b2c2f9d9b0e6bc80"
    sha256 cellar: :any_skip_relocation, sonoma:        "81aadb992e4d27ad217a30f557fad751c828be089f237cce4e7a89fa84ed4e33"
    sha256 cellar: :any_skip_relocation, ventura:       "81aadb992e4d27ad217a30f557fad751c828be089f237cce4e7a89fa84ed4e33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d2f18e55f980c8b3c8fc68bd8649aff84bd146129fe3c42f7379ea23aab0392"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.buildSource=#{tap.user}"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
  end

  test do
    system "git", "init", "--initial-branch=main"

    output = shell_output("#{bin}/lazygit log 2>&1", 1)
    assert_match "errors.errorString terminal not cursor addressable", output

    assert_match version.to_s, shell_output("#{bin}/lazygit -v")
  end
end
