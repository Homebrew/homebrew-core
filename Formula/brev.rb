class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.37.tar.gz"
  sha256 "f5b88861961d1275d48f8c63d868f202c438a4b75561e37662937ae64b7de37c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b0a90a8a5407c836da4b5005e65678e38abbb66e42fafcbe63bf359a9c88380"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2436212b344e00e5fe1bb733e9568a4921d1a0f5a02cdaf293d8a45c5fb05fb"
    sha256 cellar: :any_skip_relocation, monterey:       "dbe2282e9a5d2012224e9176138a65c5071ac1e0ac0c0630026b92016819e2ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac0c41a0958584ebc56cd2458ae880a640196dfedd47e63a1e3854d7a19f0c8e"
    sha256 cellar: :any_skip_relocation, catalina:       "0f7734a4e5c299432b836fd6c437f8954805f16fcd38d68905a3c77f0b42a77e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd3471f3b562ce9384460687bb41282ec25d6c2559a0ca8f37eb8eab08348fd0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
