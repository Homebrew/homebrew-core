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
    sha256 cellar: :any, arm64_golden_gate: "0d063d417d94fa8797075e64c3c6853a92d1fb8df8c5e24c0699f316a17cd226"
    sha256 cellar: :any, arm64_tahoe:       "4e9b85fb979ebcb8ce7ec1f3eb9b400fe18af1ac2a6c6b431c45220525f303a4"
    sha256 cellar: :any, arm64_sequoia:     "34e43d0860debc89391f98072cceb4fc4f9298df5ef7bfa3194bbbc396c8b495"
    sha256 cellar: :any, arm64_linux:       "a80396a5853c3f0759e5c0709d10c497db1c46e743699911ed430e3f0bb7f674"
    sha256 cellar: :any, x86_64_linux:      "2cea3d649ee7339ff74f837432902606e3d17df7a4bcef12252ca97277b1b359"
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
