class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/1.0.2.tar.gz"
  sha256 "d3855ddbaf11cac3f0f164937faa1153ea9d1ab41175989311eab674d9b4a635"

  bottle do
    cellar :any_skip_relocation
    sha256 "b384848f48f6e1d714a578a3301a5b4cb520b7fb3389537e08a6d7e4d63170f4" => :mojave
    sha256 "a79032313a80d5d55b35bd6ec057f1b990f613da3dbfc278e631168365776176" => :high_sierra
    sha256 "31ea9f63acbca72f594346256122d4898b2ce65b1ca53a0785b00bef62700628" => :sierra
    sha256 "a383a729459136fab43a0ce6e1f822fecb22bcb351e7fec32eee9ac6810c7363" => :el_capitan
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
