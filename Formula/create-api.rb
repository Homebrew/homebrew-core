class CreateApi < Formula
  desc "Delightful code generator for OpenAPI specs"
  homepage "https://github.com/CreateAPI/CreateAPI"
  url "https://github.com/CreateAPI/CreateAPI/archive/refs/tags/0.1.1.tar.gz"
  sha256 "2a0529e700a1e3dd4a0dbbaa3c68340adf7ce6a331b85bfbcd42b494e5cf5ddb"
  license "MIT"
  head "https://github.com/CreateAPI/CreateAPI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "663256fe1d561dfa58ef70014d2c9cc37bdd716a40dc2c4d693e4fdeddc6e800"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18af8d07ebfbe51615112e91ca15307c3a0f896222dbe486f6a2a4693ab093fb"
    sha256 cellar: :any_skip_relocation, monterey:       "4d1c0939f7c82d1658bdd743dc5cff94a5d96e9af39b0c1b06585aa67333327f"
    sha256 cellar: :any_skip_relocation, big_sur:        "324849f6e0d1d33179feebd75e67ba132e231434dd135b500ee27834680671f9"
    sha256                               x86_64_linux:   "6f1c9f9e99281849add956b3fe40c08127abb00b15bd47de3b384b3785d15f38"
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
