class IosClassGuard < Formula
  desc "Objective-C obfuscator for Mach-O executables"
  homepage "https://github.com/Polidea/ios-class-guard/"
  url "https://github.com/Polidea/ios-class-guard/archive/0.8.tar.gz"
  sha256 "4446993378f1e84ce1d1b3cbace0375661e3fe2fa1a63b9bf2c5e9370a6058ff"
  license "GPL-2.0"
  head "https://github.com/Polidea/ios-class-guard.git"

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
    cellar :any_skip_relocation
    sha256 "159991d0922d6ea71dceb5f97c3024659f70c48fb91c0222186e8c108885db54" => :big_sur
    sha256 "80da4446b7d4838b965d12546d9b10ad777c24c2026248e6d49c415aad3f9771" => :arm64_big_sur
    sha256 "807b425c949e9a25331abd13967721d6f58d3a1674fcc8175744e713e81ee5d3" => :catalina
    sha256 "480f0437e5217cb8a47fcc0e9ffb6ffc62e4f81a79d5df9529320edeed479217" => :mojave
    sha256 "1962e7dde167e41141680b1347318396c0878fb8eeae55ec9f09460fcee33142" => :high_sierra
    sha256 "a7843a0767e916aa6be1509a984eb698bb54d125d06ad762fd25f4a3d6a55db1" => :sierra
    sha256 "0bb9abaac82cbc4e66a12493548659197559a01a779db6ceda4cf6c4439ea0bb" => :el_capitan
    sha256 "4cada6d32bb82fbd8ad2afa58b7041bd5da12dc5d9fceab6277eec97459a2d33" => :yosemite
    sha256 "4eddde784c843628cb8bcb8c971142683c5a17373058f5bda62356b432dec00a" => :mavericks
  end

  depends_on xcode: :build

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
