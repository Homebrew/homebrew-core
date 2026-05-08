class Licenseplist < Formula
  desc "License list generator of all your dependencies for iOS applications"
  homepage "https://www.slideshare.net/mono0926/licenseplist-a-license-list-generator-of-all-your-dependencies-for-ios-applications"
  url "https://github.com/mono0926/LicensePlist/archive/refs/tags/3.27.7.tar.gz"
  sha256 "133f0400707121d3e0d88dd63b22a63f0b430bd6ff87acc7e69104050e93aa6e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1acf6af14f691a5902c9106b2b67ac182571450d8ef9475d0a2abe5891739415"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1164010b4da2346f2c895953f3bc821df8a54e1caa27517f2d2098bbb4d7862a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd06129e6cdd22b83c0a43ef1c92d13481818692d7bdad2bee740a26834c44ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "c17041088cc0cf11cabfcdc44821464d618ae74d0c5fd9fa7341d3644ed78c54"
  end

  depends_on :macos

  uses_from_macos "swift" => :build, since: :sonoma # swift 6.0+

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/license-plist"
    generate_completions_from_executable(bin/"license-plist", "--generate-completion-script")
  end

  test do
    (testpath/"Cartfile.resolved").write <<~EOS
      github "realm/realm-swift" "v10.20.2"
    EOS
    assert_match "None", shell_output("#{bin}/license-plist --suppress-opening-directory")
  end
end
