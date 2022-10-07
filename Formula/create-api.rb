class CreateApi < Formula
  desc "Delightful code generator for OpenAPI specs"
  homepage "https://github.com/CreateAPI/CreateAPI"
  url "https://github.com/CreateAPI/CreateAPI/archive/refs/tags/0.1.1.tar.gz"
  sha256 "2a0529e700a1e3dd4a0dbbaa3c68340adf7ce6a331b85bfbcd42b494e5cf5ddb"
  license "MIT"
  revision 1
  head "https://github.com/CreateAPI/CreateAPI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7f83cdedc16bd6b86dddc7931ed1b8de1c6fa1894a5d5d5fa9c6b8552bc00a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f8b21dc1fa43c8777e273fc8666337a23fc676e9127d8740344c53284707f38"
    sha256 cellar: :any_skip_relocation, monterey:       "4889a2c84ee571408001aa8f2000552d6243cc725ea4e86836d05a01ef01e1cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b161768bb43068fae43e52d377b38b1f0e5e0602ceffafa478634eea8cd8804"
    sha256                               x86_64_linux:   "0b3dc2c272ebf9fd748aeacdaa5eba1fcac7bb9a1fdba49d8b5083aa7937c8c3"
  end

  depends_on xcode: "13.0"

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/create-api"
    pkgshare.install "Tests/Support/Specs/cookpad.json" => "test-spec.json"
  end

  test do
    system bin/"create-api", "generate", pkgshare/"test-spec.json", "--config-option", "module=TestPackage"
    cd "CreateAPI" do
      system "swift", "build", "--disable-sandbox"
    end
  end
end
