class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/1.1.2.tar.gz"
  sha256 "99ccc7e107507b6898869fd763d794726360ff331ecc6dd18dfb4a2a8f76e73f"

  bottle do
    cellar :any_skip_relocation
    sha256 "d4f25281fdf275a98dc99338025cac79ad6062ba849b6e179d59c289b3c3b078" => :mojave
    sha256 "71e42b88dcfa4018a4fc5d83ebd46585f0968b548b51b35c4657b4c55ba36192" => :high_sierra
    sha256 "f0bac148bc05e2d078655e5bdd214e61c7c9238163dbecfd45c32c65f5d05a7d" => :sierra
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
