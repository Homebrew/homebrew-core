class Exercism < Formula
  desc "Command-line tool to interact with exercism.io"
  homepage "https://cli.exercism.io/"
  url "https://github.com/exercism/cli/archive/v3.0.7.tar.gz"
  sha256 "2d67a56b029769b4bad7006968704f4ea943e1e3f57b0a3c5b2b9c066c5d9ad0"
  head "https://github.com/exercism/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "527710ff61a7fe6e8e34e6c46214df3bc3db8e8f993fa0a4028e58372003a5d8" => :mojave
    sha256 "14bc43a45b2d2b8940e64cef3bf1cb0d7b4c3e7210bf5608f02f2726881e36f9" => :high_sierra
    sha256 "ff63c8245a5bad5c673839a569b800f7d8fb2a543bdd7e9d945f47abb9a8c24e" => :sierra
    sha256 "5b5e298209a7a32a45633557e82f8a82c5740141b592e92442ac3168cb763d5a" => :el_capitan
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
