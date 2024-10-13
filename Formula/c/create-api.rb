class CreateApi < Formula
  desc "Delightful code generator for OpenAPI specs"
  homepage "https://github.com/CreateAPI/CreateAPI"
  url "https://github.com/CreateAPI/CreateAPI/archive/refs/tags/0.2.0.tar.gz"
  sha256 "9f61943314797fe4f09b40be72e1f72b0a616c66cb1b66cd042f97a596ffd869"
  license "MIT"
  head "https://github.com/CreateAPI/CreateAPI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "125fe793fe54ddf9e5603cabd21b699a1e8453b4cd3fd969e0cb4f124d310ac2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8d17d4dbb015aa085d070861eae7aaac01bf63a5897b48489582fa88f350a620"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a23b2e7e6929d586771bcab06de3f1dd785918828dab95d9f58ae19e646c3ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f65b99b02709736555a41e9ae392c921acde1eac1a6cacc04e1977a3fd34228d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6160b88a1a896a5afd230b1708b98b9ee8a4feb2e7a2d068a41af63e5f7ffd9"
    sha256 cellar: :any_skip_relocation, sonoma:         "e2f6e3ba2228afae806bb80f1902e2b9b00c0853ed6ec6a2a2a554565dc65aeb"
    sha256 cellar: :any_skip_relocation, ventura:        "84f5410c757703de3be514f212e5dd1b06674c66237e67f41919ec800cff933a"
    sha256 cellar: :any_skip_relocation, monterey:       "3e02e51410146f3993426a2418d34d84558ee1b7d24891231b05f089a5a57f3e"
    sha256 cellar: :any_skip_relocation, big_sur:        "3cc02041040c669aedc28506411668f1e285293eef0a4736a225aca1781ff4fe"
    sha256                               x86_64_linux:   "dd0151810906d53f62239aceb79899a8b512b2cedc642239121efb7b7bf85763"
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
