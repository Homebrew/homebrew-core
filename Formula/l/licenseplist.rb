class Licenseplist < Formula
  desc "License list generator of all your dependencies for iOS applications"
  homepage "https://www.slideshare.net/mono0926/licenseplist-a-license-list-generator-of-all-your-dependencies-for-ios-applications"
  url "https://github.com/mono0926/LicensePlist/archive/refs/tags/3.27.1.tar.gz"
  sha256 "6faabde2834f2d45f6467ed34d404a8ee73dcb505f00a8f1a84c55b369a7029b"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3d29de5e06caab7668af33fb9b3317de75946a3954a7a9193c0ad8c3714fad4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e54f055c3e29a8aff0f85e950ab1c020a754f0aef9d0cc611dd2ce5805043e68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0b3dcfa0ba7517e413f75da4cc7599fb5e5dd537d6b97441d1c588bd87cfbeb"
    sha256 cellar: :any,                 arm64_ventura: "8c21ddfdff8381555f285a561c3f510c7ab4fbeda13888fb9f33b0f10846d85a"
    sha256 cellar: :any_skip_relocation, sonoma:        "703046bd779a84a179d2d9f8b5a47008aa59b589cf541e3c80f43ebd4cdd55ce"
    sha256 cellar: :any,                 ventura:       "dd3dc64ce46e592dfd9c3ad0b223366ab6556865a5ff2ea3d5392f93a030466e"
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
