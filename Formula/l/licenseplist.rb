class Licenseplist < Formula
  desc "License list generator of all your dependencies for iOS applications"
  homepage "https://www.slideshare.net/mono0926/licenseplist-a-license-list-generator-of-all-your-dependencies-for-ios-applications"
  url "https://github.com/mono0926/LicensePlist/archive/refs/tags/3.24.11.tar.gz"
  sha256 "a4b6bf1fb050d6905f52c462f734990a45e604ec80ac74424620c3c4f89fd65f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "87c277b768ef63a84610c071f8e96c60bc36a6126c7d4f6f50c911dfdcf9a06a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5005436abb8a9f4fbe0f34541b8db70918b9317eb5d49a224df05180f0ad8f63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd0f916e8a2f76aa124779f49384fbf04f539334ce0efd4856d7ce30431d0e35"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb73666c255b6b66e49bf8696c7e68e28a115e298079d3db81716c17edee90f4"
    sha256 cellar: :any_skip_relocation, ventura:        "5f45fccde816c6809040b38cb7aa090efa50931de527073da5833c84443f4e73"
    sha256 cellar: :any_skip_relocation, monterey:       "d6babdaccbcfc62dfc9e0fc27e75c0b12a8f9501584348d955ad83c917d01b35"
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
