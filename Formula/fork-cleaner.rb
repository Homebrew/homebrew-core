class ForkCleaner < Formula
  desc "Cleans up old and inactive forks on your GitHub account"
  homepage "https://github.com/caarlos0/fork-cleaner"
  url "https://github.com/caarlos0/fork-cleaner/archive/v1.4.2.tar.gz"
  sha256 "a3ce478f277e2c2a84661ecf92ad42ffeceb8836bc6e5d182f7fad7b6ec9ddd8"

  bottle do
    cellar :any_skip_relocation
    sha256 "71c459d32e032eaf290e67e364e69ba7e404b65df89b15697cf747c2af67ab0f" => :high_sierra
    sha256 "67296a4bf5445e45045ecc07441191e541554e307ad536f28a0f53b9148c4932" => :sierra
    sha256 "c874fc4e1c1bb5bc586f54c67d391ce6c735b99fa4e66866ad1c08c0d63352d3" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/caarlos0/fork-cleaner"
    dir.install buildpath.children
    cd dir do
      system "dep", "ensure"
      system "make"
      bin.install "fork-cleaner"
      prefix.install_metafiles
    end
  end

  test do
    output = shell_output("#{bin}/fork-cleaner 2>&1", 1)
    assert_match "missing github token", output
  end
end
