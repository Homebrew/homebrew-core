class Exercism < Formula
  desc "Command-line tool to interact with exercism.io"
  homepage "https://cli.exercism.io/"
  url "https://github.com/exercism/cli/archive/v3.0.8.tar.gz"
  sha256 "da6eb82e852feb04c65e479ef2d6498cd7f147dcafd3cb8a023454baa2043a0e"
  head "https://github.com/exercism/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d72972acaea2a65b58dcdb7eee822ecd7903818789b3a3c536f5a5782450dad0" => :high_sierra
    sha256 "5059f764e394f48bd7459bf5de9608d883cb7a05ceebc7849392d6c284dac100" => :sierra
    sha256 "d957ffe5a898df25c87ac2ca35ca150fa8dd96c932180e16bda2acbfa0a8b199" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/exercism/cli").install buildpath.children
    cd "src/github.com/exercism/cli" do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", bin/"exercism", "exercism/main.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/exercism version")
  end
end
