class CreateApi < Formula
  desc "Delightful code generator for OpenAPI specs"
  homepage "https://github.com/CreateAPI/CreateAPI"
  url "https://github.com/CreateAPI/CreateAPI/archive/refs/tags/0.0.5.tar.gz"
  sha256 "c250ff140af83e093d86fef0dd18b87363ae91a087c0804bedb40f9922989093"
  license "MIT"
  head "https://github.com/CreateAPI/CreateAPI.git", branch: "main"

  depends_on xcode: "13.0"

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/create-api"
    pkgshare.install "Tests/CreateAPITests/Specs/cookpad.json" => "test-spec.json"
  end

  test do
    system bin/"create-api", "generate", "--package", "TestPackage", "--output", ".", pkgshare/"test-spec.json"
    cd "TestPackage" do
      system "swift", "build", "--disable-sandbox"
    end
  end
end
