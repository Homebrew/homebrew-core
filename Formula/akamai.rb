class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/1.0.3.tar.gz"
  sha256 "3587fb0ea21a30d3be5e1dc39dd9f2100ae1cefe466fd434cdd6bd2c04b8dc93"

  bottle do
    cellar :any_skip_relocation
    sha256 "864f04fab0234c5b927d01e9f6fb5ab00fbfb222bb5676ce0b26c60b66cc5641" => :mojave
    sha256 "6f27faf70b137c7f22fdcef2708fc3b3de1f551404690d6583953d3c0d4ae654" => :high_sierra
    sha256 "1985dd3787e734a9274228ca4dad5edcb90e8a3dd03e730b08c84f5c44abab6f" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"

    srcpath = buildpath/"src/github.com/akamai/cli"
    srcpath.install buildpath.children

    cd srcpath do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-tags", "noautoupgrade nofirstrun", "-o", bin/"akamai"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "Purge", shell_output("#{bin}/akamai install --force purge")
  end
end
