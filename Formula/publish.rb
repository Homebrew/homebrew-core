class Publish < Formula
  desc "Static site generator for Swift developers"
  homepage "https://github.com/JohnSundell/Publish"
  url "https://github.com/JohnSundell/Publish/archive/0.9.0.tar.gz"
  sha256 "e098a48e8763d3aef9abd1a673b8b28b4b35f8dbad15218125e18461104874ca"
  license "MIT"
  head "https://github.com/JohnSundell/Publish.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "867ee726868a7549be1a54c8c9219381b20503473d815843234e79172c2d8721"
    sha256 cellar: :any_skip_relocation, monterey:       "596dded5de263f2e792564d00b7ad6df19100e3679a3a45638f3778e0972a5df"
    sha256                               x86_64_linux:   "2c34e93726662d9416d7635aa995303cd0bd0cafb56c687b7b0c9ba9c7678a95"
  end

  # https://github.com/JohnSundell/Publish#system-requirements
  depends_on xcode: ["12.5", :build]
  # missing `libswift_Concurrency.dylib` on big_sur`
  depends_on macos: :monterey

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/publish-cli" => "publish"
  end

  test do
    mkdir testpath/"test" do
      system "#{bin}/publish", "new"
      assert_predicate testpath/"test"/"Package.swift", :exist?
    end
  end
end
