class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.154.0",
      revision: "e8ea231122dc98ec2315eff2df2defc5191764d6"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "02fa6cfd01100acf7644c2c28e2379ebab709c60d4b1043324e4fa361b7a0469" => :big_sur
    sha256 "2b9d6def5fd76689701e63f9c6caa6f58055b360c356a20872735cf0c234f598" => :arm64_big_sur
    sha256 "673fb1e121047103f4dcdd0b731cd981943736863505bf2c82655005e6be3206" => :catalina
    sha256 "46f547da7ed472a9d098c152134227157b3ae72e4977747425622303a5234742" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X main.version=#{version} -X main.commit=#{Utils.git_head} -X main.builtBy=homebrew",
             *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
