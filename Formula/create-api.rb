class CreateApi < Formula
  desc "Delightful code generator for OpenAPI specs"
  homepage "https://github.com/CreateAPI/CreateAPI"
  url "https://github.com/CreateAPI/CreateAPI/archive/refs/tags/0.1.0.tar.gz"
  sha256 "eb05a0129153841e9af300acae10533a6926689fd6e5ed67ddb69c1c18b85e36"
  license "MIT"
  head "https://github.com/CreateAPI/CreateAPI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99d263515ea2c93919179d5b468a29b4da7c9b7c6322448506e41b36f925b93b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7c7138c05f97400c2df305aafd3897275d2f38e6052ae2571cb3501dd029d44"
    sha256 cellar: :any_skip_relocation, monterey:       "3a3139fafa9aae06fe3493f8e6c0a37cf226c517d4c8411f537a6a10de679b25"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed75f9fefcaf8788a29096b708d1a6073dbff5c3317f659bffa9505d12399901"
    sha256                               x86_64_linux:   "e601264f7e09695da3eeddec27c7555c089627ed0b98a8eea93ff410caf5db6a"
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
