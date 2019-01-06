class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/1.1.1.tar.gz"
  sha256 "fd29fb3639f0c6d0d3c0b9d19ffebb935d8d9ea693533d1255c42f55a3860a00"

  bottle do
    cellar :any_skip_relocation
    sha256 "16764dec8d1dbec939ff77658fbd97307750e6fd285351bbbd7b3a05698d2137" => :mojave
    sha256 "9075875740404cd16e557546722e47535979082a4b8a21b35973bb08a5c91cd3" => :high_sierra
    sha256 "cf3a27a0a65bdd49e9d2cae18bde2ff6b72989a541388bec9c4ce37ffddc07ba" => :sierra
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
