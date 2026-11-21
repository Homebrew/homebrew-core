class LdidProcursus < Formula
  desc "Put real or fake signatures in a Mach-O binary"
  homepage "https://github.com/ProcursusTeam/ldid"
  url "https://github.com/ProcursusTeam/ldid/archive/refs/tags/v2.1.5-procursus8.tar.gz"
  version "2.1.5-procursus8"
  sha256 "d8034f4c76c1d042e5e6984c79c5da5a0fb4c08e8d2fb20b3691ffa39d377000"
  license "AGPL-3.0-or-later"
  compatibility_version 1
  head "https://github.com/ProcursusTeam/ldid.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+-procursus\d+)$/i)
  end

  bottle do
    manifest_sha256 "3d09a026780017761614ca8f7aaff371e8298a569aa80e2ccb96bc30be5d3461"
    sha256 cellar: :any, arm64_golden_gate: "7fc86491ac3977da934d01c17c6ce6d9da098ce0e6134bbef40421e21649d2cf"
    sha256 cellar: :any, arm64_tahoe:       "6c553b7a6d90b4da13987433251744f0db14ae1ad70310725cdd1cc774288d71"
    sha256 cellar: :any, arm64_sequoia:     "3f23496c0812e6e9defc561b8cf2c887136e410086d37c237f58221dddd2c781"
    sha256 cellar: :any, arm64_linux:       "6424070b6b0d7c63ced664bb2a512edbf7648a67fddae7025885db954d06b598"
    sha256 cellar: :any, x86_64_linux:      "2fa0009adc5ebb3c5a69a5b39bbabb8f7947bad5a9d15f2a8fd452a4eee3b429"
  end

  depends_on "pkgconf" => :build
  depends_on "libplist"
  depends_on "openssl@4"

  conflicts_with "ldid", because: "ldid installs a conflicting ldid binary"

  deny_network_access!

  def install
    system "make", "install", "PREFIX=#{prefix}"
    zsh_completion.install "_ldid"
  end

  test do
    (testpath/"test.xml").write <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
      	<key>platform-application</key>
      	<true/>
      	<key>com.apple-private.security.no-container</key>
      	<true/>
      	<key>com.apple-private.skip-library-validation</key>
      	<true/>
      </dict>
      </plist>
    XML
    cp test_fixtures("mach/fat.dylib"), testpath
    system bin/"ldid", "-Stest.xml", "fat.dylib"
    assert_match (testpath/"test.xml").read, shell_output("#{bin}/ldid -arch x86_64 -e fat.dylib")
    assert_match version.to_s, shell_output("#{bin}/ldid 2>&1")
  end
end
