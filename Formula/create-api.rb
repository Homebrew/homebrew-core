class CreateApi < Formula
  desc "Delightful code generator for OpenAPI specs"
  homepage "https://github.com/CreateAPI/CreateAPI"
  url "https://github.com/CreateAPI/CreateAPI/archive/refs/tags/0.1.1.tar.gz"
  sha256 "2a0529e700a1e3dd4a0dbbaa3c68340adf7ce6a331b85bfbcd42b494e5cf5ddb"
  license "MIT"
  revision 1
  head "https://github.com/CreateAPI/CreateAPI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea82962c830a75f2aa103e2784d7381d3d18a713de84a4a7cdac3bb141666ef5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fd943082f76afd4a3d720dfd6755506bdc5707ebab8e369220bf421b1f6126d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "656971de18aae0e52439531a0e352b9ecf02be4084b7950063ce45e460df5bd3"
    sha256 cellar: :any_skip_relocation, ventura:        "6a6791cb2c18c74b7691b1ce99c891bc1eae88cc73f5cb8234340c19082e2f0f"
    sha256 cellar: :any_skip_relocation, monterey:       "2f744934002eae068f08ae003a0a236e5601827b02f1c856c1685726f6aa7498"
    sha256 cellar: :any_skip_relocation, big_sur:        "d51f35fb247060f2744e6db98bce27ab239d6ee6e09b8acdcc19c7edd92120e9"
    sha256                               x86_64_linux:   "1d929a93961640d42c2f2fc286cb0b22b29955e164962395df4dd70f5a057a7b"
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
