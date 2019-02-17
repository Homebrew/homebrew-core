class Cli53 < Formula
  desc "Command-line tool for Amazon Route 53"
  homepage "https://github.com/barnybug/cli53"
  url "https://github.com/barnybug/cli53/archive/0.8.13.tar.gz"
  sha256 "1ca98dc7a3b0d580a02a7debce659e688b410ae3437936188961f71b1b00861c"

  bottle do
    cellar :any_skip_relocation
    sha256 "6638c669af3f120a6b641706702dc529f34836e2a7776b724ad4acead6aaeed9" => :mojave
    sha256 "e39a63d966ad1e667711f5d4ae7e344785d9aedf659dea7fb8460b737c07a60a" => :high_sierra
    sha256 "04b4f7c4b3e8c55230e358cdb32ea3844652946769cc81121e3688cd2f1c3918" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/barnybug"
    ln_s buildpath, buildpath/"src/github.com/barnybug/cli53"

    system "make", "build"
    bin.install "cli53"
  end

  test do
    assert_match "list domains", shell_output("#{bin}/cli53 help list")
  end
end
