class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/0.5.0.tar.gz"
  sha256 "c8a78c9c84c5796936028e3487cbd7bfa256fee505eae07e813d32e02fa2a09f"

  bottle do
    cellar :any_skip_relocation
    sha256 "225f31bd4166ec6537ff8a2ddea57bb11652e8771c2465c2f64dd64311f4d026" => :high_sierra
    sha256 "a32b5cf2669fe402ab8fc4905fceca236348dc738298bf8f7551f41fdd8b049e" => :sierra
    sha256 "6dd3e1cef09fd226521b44cf0d6f3cb1c9bd5b17671c5c2592bdd2915ff53b60" => :el_capitan
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
