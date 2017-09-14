class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/0.4.0.tar.gz"
  sha256 "9364ccedd21dfe520d59a05ea1d0fbd83c1b4da8e2dbb6686c829a3583e626fc"

  bottle do
    cellar :any_skip_relocation
    sha256 "e997cd826985bb4b41081866e8dfb3e4d10d544013057eb096f4c9b79fe30bd3" => :sierra
    sha256 "f0c99cf085a3540494a3ff12832b81077ed0bd42e851e5f8892944ddcee2d5f1" => :el_capitan
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
    end
  end

  test do
    assert_match "Purge", shell_output("#{bin}/akamai install --force purge")
  end
end
