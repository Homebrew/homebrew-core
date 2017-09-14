class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/0.4.0.tar.gz"
  sha256 "9364ccedd21dfe520d59a05ea1d0fbd83c1b4da8e2dbb6686c829a3583e626fc"

  bottle do
    cellar :any_skip_relocation
    sha256 "e3022b69636cc10407739c3497d6fd4250ded19ce0729415699efc2799720134" => :sierra
    sha256 "d3e72e38b1d1b66adb10ec4f230873b78bc12b9cbe8ba1877b2ebe237f264af0" => :el_capitan
    sha256 "01c4c5f3da394c43280aa5546fc70af4c7ff8b2f015e3e78cde9ee3f14a720da" => :yosemite
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
