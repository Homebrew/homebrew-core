class Ironcli < Formula
  desc "Go version of the Iron.io command-line tools"
  homepage "https://github.com/iron-io/ironcli"
  url "https://github.com/iron-io/ironcli/archive/0.1.6.tar.gz"
  sha256 "2b9e65c36e4f57ccb47449d55adc220d1c8d1c0ad7316b6afaf87c8d393caae6"

  bottle do
    cellar :any_skip_relocation
    sha256 "232ec828638d85d59736812abb50c879000f430724fe1575375ef0a41777a52e" => :catalina
    sha256 "99be404dee323b0bb405e77576414392ce3ff66462230efa129636e6a4e2c2a3" => :mojave
    sha256 "c4f4ad82734f93b32a2f64e1adaaf493fa38b4e34cbc9298fbbdc02851003343" => :high_sierra
    sha256 "14d4bcd4ac89e89fb09b27994ba372d1e25690724c99b7ffbfb0231466c01bca" => :sierra
    sha256 "62bed7f56cf23a148407527ff2b1234638ae0b365806ccc79c602ee081eed1dc" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/iron-io/ironcli").install buildpath.children
    cd "src/github.com/iron-io/ironcli" do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", bin/"iron"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"iron", "-help"
  end
end
