class Exercism < Formula
  desc "Command-line tool to interact with exercism.io"
  homepage "https://cli.exercism.io/"
  url "https://github.com/exercism/cli/archive/v3.0.11.tar.gz"
  sha256 "544088bc562a8624e3527dd9d3ccf944dc4923b644bcdf49ef04e6d0ee48ddad"
  head "https://github.com/exercism/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b3ff5e69c47a59e474eb667b04161882a0a22e7473f432c68f940d7fa51d2720" => :mojave
    sha256 "a874ff0731e29ae3b1739468677c763ada9d6b5405faad5a23a323a49376a927" => :high_sierra
    sha256 "16a0d5649378792c5abba4e443b6f1f365465121667af6cd990de225d6e6725d" => :sierra
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
