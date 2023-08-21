class IosClassGuard < Formula
  desc "Objective-C obfuscator for Mach-O executables"
  homepage "https://github.com/Polidea/ios-class-guard/"
  url "https://github.com/Polidea/ios-class-guard/archive/0.8.tar.gz"
  sha256 "4446993378f1e84ce1d1b3cbace0375661e3fe2fa1a63b9bf2c5e9370a6058ff"
  license "GPL-2.0"
  head "https://github.com/Polidea/ios-class-guard.git", branch: "master"

  # The latest version tags in the Git repository are `0.8` (2015-10-14) and
  # `0.6` (2014-08-20) but versions before these are like `3.5` (2013-11-16),
  # `3.4` (2012-11-19), `3.3.4` (2011-09-03), etc. The older releases like `3.5`
  # are wrongly treated as newer but the GitHub repository doesn't mark a
  # "latest" release, so we can only work around this by restricting matching
  # to 0.x releases for now. If the major version reaches 1.x in the
  # future, this check will also need to be updated.
  livecheck do
    url :stable
    regex(/^v?(0(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2cfa45ab4d2e9f5ff160c3e88426c890c83d5a87997fff438e04d07cd4d68467"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4953b61e871a9935955ce26115619c081b15a5712decba1502b1d50b8d311cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "80da4446b7d4838b965d12546d9b10ad777c24c2026248e6d49c415aad3f9771"
    sha256 cellar: :any_skip_relocation, ventura:        "4864bb18b6e3712c92bede68182d7d8345e35b98da0327b8bbffbfc07891ddee"
    sha256 cellar: :any_skip_relocation, monterey:       "c6ac0f4d85d53a86ee0de247c7119f776506830d4d7d2df26eb2ecebc1fa20f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "159991d0922d6ea71dceb5f97c3024659f70c48fb91c0222186e8c108885db54"
    sha256 cellar: :any_skip_relocation, catalina:       "807b425c949e9a25331abd13967721d6f58d3a1674fcc8175744e713e81ee5d3"
    sha256 cellar: :any_skip_relocation, mojave:         "480f0437e5217cb8a47fcc0e9ffb6ffc62e4f81a79d5df9529320edeed479217"
    sha256 cellar: :any_skip_relocation, high_sierra:    "1962e7dde167e41141680b1347318396c0878fb8eeae55ec9f09460fcee33142"
    sha256 cellar: :any_skip_relocation, sierra:         "a7843a0767e916aa6be1509a984eb698bb54d125d06ad762fd25f4a3d6a55db1"
    sha256 cellar: :any_skip_relocation, el_capitan:     "0bb9abaac82cbc4e66a12493548659197559a01a779db6ceda4cf6c4439ea0bb"
  end

  depends_on xcode: :build
  depends_on :macos

  def install
    xcodebuild "-workspace", "ios-class-guard.xcworkspace",
               "-scheme", "ios-class-guard",
               "-configuration", "Release",
               "SYMROOT=build", "PREFIX=#{prefix}", "ONLY_ACTIVE_ARCH=YES"
    bin.install "build/Release/ios-class-guard"
  end

  test do
    (testpath/"crashdump").write <<~EOS
      1   MYAPP                           0x0006573a -[C03B setR02:] + 42
    EOS
    (testpath/"symbols.json").write <<~EOS
      {
        "C03B" : "MyViewController",
        "setR02" : "setRightButtons"
      }
    EOS
    system "#{bin}/ios-class-guard", "-c", "crashdump", "-m", "symbols.json"
  end
end
