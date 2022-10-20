class Ironcli < Formula
  desc "Go version of the Iron.io command-line tools"
  homepage "https://github.com/iron-io/ironcli"
  url "https://github.com/iron-io/ironcli/archive/0.1.6.tar.gz"
  sha256 "2b9e65c36e4f57ccb47449d55adc220d1c8d1c0ad7316b6afaf87c8d393caae6"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ddf8d70647db887d9f340734921103d352617dd54614bf3cf71b8330e57d0a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b37c7bf74c87bd1ceebcad3b17bf9cc07f940339361be2601e4029f5f8244bbc"
    sha256 cellar: :any_skip_relocation, monterey:       "cb54c07fa03cbe8487c51bd5edad0510741e2d5b32eabbd93f545a529db6bdc4"
    sha256 cellar: :any_skip_relocation, big_sur:        "cda14c4a548c7dbc63045566cbd9d2c47b0fa12934436c63c9505bf38ad5173b"
    sha256 cellar: :any_skip_relocation, catalina:       "232ec828638d85d59736812abb50c879000f430724fe1575375ef0a41777a52e"
    sha256 cellar: :any_skip_relocation, mojave:         "99be404dee323b0bb405e77576414392ce3ff66462230efa129636e6a4e2c2a3"
    sha256 cellar: :any_skip_relocation, high_sierra:    "c4f4ad82734f93b32a2f64e1adaaf493fa38b4e34cbc9298fbbdc02851003343"
    sha256 cellar: :any_skip_relocation, sierra:         "14d4bcd4ac89e89fb09b27994ba372d1e25690724c99b7ffbfb0231466c01bca"
    sha256 cellar: :any_skip_relocation, el_capitan:     "62bed7f56cf23a148407527ff2b1234638ae0b365806ccc79c602ee081eed1dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65022e0f3c0a56a87bceb8bd8dd8d6a786b77d70c00c9170e5fc30e473a79264"
  end

  disable! date: "2022-09-14", because: :unmaintained

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
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
