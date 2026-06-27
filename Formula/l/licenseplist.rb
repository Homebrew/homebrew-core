class Licenseplist < Formula
  desc "License list generator of all your dependencies for iOS applications"
  homepage "https://www.slideshare.net/mono0926/licenseplist-a-license-list-generator-of-all-your-dependencies-for-ios-applications"
  url "https://github.com/mono0926/LicensePlist/archive/refs/tags/3.27.9.tar.gz"
  sha256 "bcdd7f7f81b75458b377b3ed65b7fc972b417960bfe4e0e0b388fa7b91011230"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8dff0bf1eb6af2380e91f60945e68331e2fcc85a7896ab3e664536874eaf7382"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f050c5b1793925021b18612d0bfde2ee1675a3cd4be966501c0ef75fd13c0c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e2c9df2cca3dd38075a784e7d58af6860a20b5558a745f93bd7ea23616b6867"
    sha256 cellar: :any_skip_relocation, sonoma:        "030e54873dcdb20cc0ac53bfb3b434fa41e5abc937825155c4afd34b5f421860"
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
