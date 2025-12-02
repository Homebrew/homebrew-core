class Publish < Formula
  desc "Static site generator for Swift developers"
  homepage "https://github.com/JohnSundell/Publish"
  url "https://github.com/JohnSundell/Publish/archive/refs/tags/0.9.0.tar.gz"
  sha256 "e098a48e8763d3aef9abd1a673b8b28b4b35f8dbad15218125e18461104874ca"
  license "MIT"
  revision 2
  head "https://github.com/JohnSundell/Publish.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d712d342ef986f6c33dee070c00858ca051c1341b510a1ed9bfffd323c38d72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12bb9d41814cacbe362e02d37825f9eabb5c2c228d2502441389a31deff9cd06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d595b1f7732f64fd874095b0c17ec22b77d7261fa83e0324f4657bfd8dbbedf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75ad288c89a4abfff3648d4628b71133b15a9da2a7e85ea2ce72558c8b6a5ced"
    sha256 cellar: :any_skip_relocation, sonoma:        "4653f1571901ea7091329d5f935e8a5c05b2c7a5d9a8c8751b9a0ad6052547e4"
    sha256 cellar: :any_skip_relocation, ventura:       "4e568dd197329c4fe8ef509c03dbc0071615353caccd1fca8307b97a039fa08c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f58f789837bfe9b47b668faf048f2324176d665cc91d8f28b8bd3e6644425378"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbf8d184068be460c2c8fb09aa1faad7180b1341bd50f670d7ca97a6d93e8672"
  end

  # https://github.com/JohnSundell/Publish#system-requirements
  depends_on xcode: ["13.0", :build]
  # missing `libswift_Concurrency.dylib` on big_sur`
  depends_on macos: :monterey

  uses_from_macos "swift" => :build

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "-c", "release"
    bin.install ".build/release/publish-cli" => "publish"
  end

  test do
    mkdir testpath/"test" do
      system bin/"publish", "new"
      assert_path_exists testpath/"test/Package.swift"
    end
  end
end
