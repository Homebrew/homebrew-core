class Licenseplist < Formula
  desc "License list generator of all your dependencies for iOS applications"
  homepage "https://www.slideshare.net/mono0926/licenseplist-a-license-list-generator-of-all-your-dependencies-for-ios-applications"
  url "https://github.com/mono0926/LicensePlist/archive/refs/tags/3.26.0.tar.gz"
  sha256 "cf9d4060806d12981328d98c81a24c76c7a70c6716fd7a2269f3f2d23c30b6fd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "774d4bba3eb81b30ffbc0ae774741c19c468f4d5ad61d2aac53328569ce9816a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fab21cc4a4a6539e7b5b68b00a82b1b47f6d156876abaa26523ad92c859b3497"
    sha256 cellar: :any,                 arm64_ventura: "8280eb4be57b63c4bc9c4ff042742d9a3d97f266175e7fa2a6e75b5b67635856"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6161ed3859e2579f707b57e656af4a0834c373013fa65eacee8318ca466249c"
    sha256 cellar: :any,                 ventura:       "b24b5485f266bb8651ccec6b185a5a8cc934dbe2b5a9a361f30060d16619203b"
  end

  depends_on :macos

  uses_from_macos "swift" => :build, since: :sonoma # swift 6.0+

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/license-plist"
  end

  test do
    (testpath/"Cartfile.resolved").write <<~EOS
      github "realm/realm-swift" "v10.20.2"
    EOS
    assert_match "None", shell_output("#{bin}/license-plist --suppress-opening-directory")
  end
end
