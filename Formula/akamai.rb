class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/1.1.0.tar.gz"
  sha256 "d1fcb43ad1792ed9d911e2fde9ca151aeef06c03c49258c40a308be69c73adb2"

  bottle do
    cellar :any_skip_relocation
    sha256 "8524d114bdea37d871e66f1d83eae456851d2a7427e42fd8843f674127f1b2d4" => :mojave
    sha256 "8080e803f11d79173b5d7da51f1c2182b8cb8e1dfc71af5f428fb53e5f32e60c" => :high_sierra
    sha256 "f3b1f4afacb62da8b49822fb664e2074015eef863079c79e55f85696bd888b9e" => :sierra
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
