class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/0.4.1.tar.gz"
  sha256 "a8b772aaa1f8721f7924ca031432c8dc81aeb8fb381eece8325412f0d6322312"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5521d29a9283f9b91ff2053dc0fadb7884359fbe42e7558037ee1741485b9a4" => :high_sierra
    sha256 "b4a3356d993a58a82b1425629537c38dd4d1fc289243ce13de2d5b6d99ee0031" => :sierra
    sha256 "afc624e735e921ca4715dcf4a3a813b9d36301e1323a2fb914059ff837c7a3a1" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"

    srcpath = buildpath/"src/github.com/akamai/cli"
    srcpath.install buildpath.children

    cd srcpath do
      system "glide", "install"
      system "go", "build", "-tags", "noautoupgrade nofirstrun", "-o", bin/"akamai"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "Purge", shell_output("#{bin}/akamai install --force purge")
  end
end
