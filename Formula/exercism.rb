class Exercism < Formula
  desc "Command-line tool to interact with exercism.io"
  homepage "http://cli.exercism.io"
  url "https://github.com/exercism/cli/archive/v3.0.6.tar.gz"
  sha256 "f990789929ce41e9bfa698204194dbc14d9550fc17568d39e48f79af5d5eae79"
  head "https://github.com/exercism/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2897796c59120f4a07b0db7f29f9b4a09ef5e7021cac950bb91a4ed2dfae6a64" => :high_sierra
    sha256 "25fa6e45df06a551ddb0a26c71a4d38c24ad3fd16fca2171813b967f1ebf4483" => :sierra
    sha256 "ab2a5d31b0de1ec8b199f823d5187f84f8d1941ba32229466c0f36a509dd136b" => :el_capitan
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
