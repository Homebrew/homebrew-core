class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/1.1.3.tar.gz"
  sha256 "5f9d2f3db4ec3b3df58726a578e2448b8a5b882d9694545ea0da7f75dca8c410"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e3b1f3e9e6d2619bd5444b1bb1c3a126bc9f2bfcccac81974129ea43c111116" => :mojave
    sha256 "7e85b290fe5843bc92b21da75a678d847e9ac7d922b9b2b7ece0cd7afbdb3ff0" => :high_sierra
    sha256 "d0ca84bd9e0591b9ca14b6a8b908a14051fe6580a5f7d981f4134db92078bcaa" => :sierra
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
