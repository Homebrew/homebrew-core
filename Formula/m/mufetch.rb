class Mufetch < Formula
  desc "Neofetch-style music cli"
  homepage "https://github.com/ashish0kumar/mufetch"
  url "https://github.com/ashish0kumar/mufetch/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "c6cba3e87e21809c640e540d396d3f72bdaa4fd42fdb79de43ada7cd6a589f0e"
  license "MIT"
  head "https://github.com/ashish0kumar/mufetch.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81a98a5e506fa81b66474770b31ba74505f78611bc9654c5277c568d64a8f036"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81a98a5e506fa81b66474770b31ba74505f78611bc9654c5277c568d64a8f036"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81a98a5e506fa81b66474770b31ba74505f78611bc9654c5277c568d64a8f036"
    sha256 cellar: :any_skip_relocation, sonoma:        "35737a128c3e4e30935175c5199426fec5487a398059d70007259fdaf74cdc8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb55fc1e510c72b555c0d91e865a0dc9a09ffabcb477f80495ce83fb7a08ba6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1beb7a21f99fa30abe3e641ddffc38e98b752de63c83eae740652491302f2aa"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/ashish0kumar/mufetch/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mufetch --version")
    output = shell_output("#{bin}/mufetch search 'Bohemian Rhapsody' 2>&1", 1)
    assert_match "No Spotify credentials found", output
  end
end
