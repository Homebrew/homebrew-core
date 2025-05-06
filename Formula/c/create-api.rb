class CreateApi < Formula
  desc "Delightful code generator for OpenAPI specs"
  homepage "https://github.com/CreateAPI/CreateAPI"
  url "https://github.com/CreateAPI/CreateAPI/archive/refs/tags/0.2.0.tar.gz"
  sha256 "9f61943314797fe4f09b40be72e1f72b0a616c66cb1b66cd042f97a596ffd869"
  license "MIT"
  revision 1
  head "https://github.com/CreateAPI/CreateAPI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3704ccee2566fbffef69ba830037391340cf4211d7ba722735175c8d97de27c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "630e2912f2280aeb27c2646cb6af920de7d9c2c5a8c01029bd6d9bfc61ccf823"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6f1b7204022524efbcc0d5488ace23dad6b074736da5938f5f2044c65466dabf"
    sha256 cellar: :any_skip_relocation, sonoma:        "cedcc24ae6221316aed18f3231693938d012c99f64af00b4cd53df7c3661c69d"
    sha256 cellar: :any_skip_relocation, ventura:       "576f78622c10ac452aba62246126c3ccfbb8ad3a684672563ce6d4a1b900a97e"
    sha256                               arm64_linux:   "c76b87eb0e141e9c261f6bc2c00294a03589280162d3cba551828f2e1e324566"
    sha256                               x86_64_linux:  "ab24ce8e1aa462a2745d77fd302a183f1f0ceb2d5e820da750f8c1f0667e38d1"
  end

  depends_on xcode: "13.0"

  uses_from_macos "swift"

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "--configuration", "release"
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
