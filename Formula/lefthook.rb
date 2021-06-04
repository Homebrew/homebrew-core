class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "d3a52befa497d1a1a9a8cacdb2d3e233c87f6920e09b032fdbfe49e99b27ecec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c2b9173da09e8b067e4da09f9aeeb83e9eb941c8f8b5a1a64212ee73e95a38f6"
    sha256 cellar: :any_skip_relocation, big_sur:       "994054301cbd256012cacdc9f18035b1126c8b9c265ed92c0fdd33f5b49f82c7"
    sha256 cellar: :any_skip_relocation, catalina:      "642f251ad57b2db7c6029ac2fabac8c3b8678ab8dd0fe8ee3cf47b6183778110"
    sha256 cellar: :any_skip_relocation, mojave:        "f4093725732ed61c70a440ccd7e7632974f33810f7b4662376a413fa3361e683"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
