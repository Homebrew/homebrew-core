class LdidProcursus < Formula
  desc "Put real or fake signatures in a Mach-O binary"
  homepage "https://github.com/ProcursusTeam/ldid"
  license "AGPL-3.0-or-later"
  revision 3
  compatibility_version 1
  head "https://github.com/ProcursusTeam/ldid.git", branch: "master"

  stable do
    version "2.1.5-procursus7"
    url "https://github.com/ProcursusTeam/ldid.git",
        tag:      "v2.1.5-procursus7",
        revision: "aaf8f23d7975ecdb8e77e3a8f22253e0a2352cef"

    patch do
      # Fix memory issues with various entitlements, remove in next release
      # See ProcursusTeam/ldid#34 and ProcursusTeam/ldid#14 for more info
      url "https://github.com/ProcursusTeam/ldid/commit/f38a095aa0cc721c40050cb074116c153608a11b.patch?full_index=1"
      sha256 "848caded901d4686444aec79cdae550832cfd3633b2090ad92cd3dd8aa6e98cf"
      type :backport
      resolves "https://github.com/ProcursusTeam/ldid/pull/34"
    end
  end

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
  depends_on "openssl@3"

  conflicts_with "ldid", because: "ldid installs a conflicting ldid binary"

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
    cp test_fixtures("mach/a.out"), testpath
    system bin/"ldid", "-Stest.xml", "a.out"
    assert_match (testpath/"test.xml").read, shell_output("#{bin}/ldid -arch x86_64 -e a.out")
  end
end
