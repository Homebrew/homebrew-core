class CreateApi < Formula
  desc "Delightful code generator for OpenAPI specs"
  homepage "https://github.com/CreateAPI/CreateAPI"
  url "https://github.com/CreateAPI/CreateAPI/archive/refs/tags/0.2.0.tar.gz"
  sha256 "9f61943314797fe4f09b40be72e1f72b0a616c66cb1b66cd042f97a596ffd869"
  license "MIT"
  revision 1
  head "https://github.com/CreateAPI/CreateAPI.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "669393e0173057f300559c44055716228c89dbf1dd91a0d898eef408c98ec184"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad0253916ad9e261c6f172f26a86114522ff41915bc71e8d4db3c85692b4ff55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d13191abe5e4a79f12ddb325118fb1d5ad2abeae2269e7a3e6b404d9913584bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d56775719688b44d0b8425c3662879424a79a337db732cb052006cbc9db988a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a285919042a7d87a437dd6baf16cd3cdeb19b957bd655c2f88ffbbca59d3d5c"
    sha256 cellar: :any_skip_relocation, ventura:       "b6fc15cf43f820ec337a72ebbf119e8837f3bd801d7d06f0125b9aaec2997dfb"
    sha256                               arm64_linux:   "2abf5d3b403a7046f7ae8d806181047a7820356c4c8c6fc70bd5b55ddbd2263c"
    sha256                               x86_64_linux:  "958733d65c7aff3b75b64ac6f5a547961d6bc0fa0242e078dddc5686e4a05ded"
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
    generate_completions_from_executable(bin/"create-api", "--generate-completion-script")
  end

  test do
    system bin/"create-api", "generate", pkgshare/"test-spec.json", "--config-option", "module=TestPackage"
    cd "CreateAPI" do
      system "swift", "build", "--disable-sandbox"
    end
  end
end
