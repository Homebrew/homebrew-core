class Licenseplist < Formula
  desc "License list generator of all your dependencies for iOS applications"
  homepage "https://www.slideshare.net/mono0926/licenseplist-a-license-list-generator-of-all-your-dependencies-for-ios-applications"
  url "https://github.com/mono0926/LicensePlist/archive/refs/tags/3.25.1.tar.gz"
  sha256 "f78887b2043d02108fda19ac587391b88ee9c911bf6558c119b261e6d220e2b5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b7115ed0eea2301764e7a7c6dd95a347b6a9e4c3e1b54813e1add1a3ee3a13f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d59a05770a35e561a0a48f7a240232b1237518da494c1936354d1fd52e3f75e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd8b9ca63a55d8845b131309ff91d16326142d86e5ff82326f9844c839dff249"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c58f8521a81b73e152bc1ba8abedd5b3ba9bcf2d617fbeaab7bb6cdc7024390d"
    sha256 cellar: :any_skip_relocation, sonoma:         "14ed6bedae42146b9415df415a3720eb296146344764be30d3cc9798a6010178"
    sha256 cellar: :any_skip_relocation, ventura:        "1ad3a02f9aa813725a18131e09cd9c2543eb74ee97cbd24230ca87ee42e0c54b"
    sha256 cellar: :any_skip_relocation, monterey:       "34f8b86092a7a9dcf1e890b246b93686a07256ed014faea9060db9317e9df9a1"
  end

  depends_on xcode: ["13.3", :build]
  depends_on :macos
  uses_from_macos "swift" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"Cartfile.resolved").write <<~EOS
      github "realm/realm-swift" "v10.20.2"
    EOS
    assert_match "None", shell_output("#{bin}/license-plist --suppress-opening-directory")
  end
end
