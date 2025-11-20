class LdidProcursus < Formula
  desc "Put real or fake signatures in a Mach-O binary"
  homepage "https://github.com/ProcursusTeam/ldid"
  license "AGPL-3.0-or-later"
  revision 2
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
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "55c501cd347ca47bb11659cb01050f8a48423c205737c2108f3bc46a19b27afc"
    sha256 cellar: :any,                 arm64_sequoia: "ab86601fb7c96f9099bf3d9b0634bd347de629fa7de675086efafc732c5e07ee"
    sha256 cellar: :any,                 arm64_sonoma:  "2caaa28ed7a37de86484d25e95c81190b1856472ddaff524b10cb98e69ced503"
    sha256 cellar: :any,                 arm64_ventura: "bca4374f9d61c9b1185cfce5d40350672f17c6e2239f9a475ab84688a356df72"
    sha256 cellar: :any,                 sonoma:        "d588f650e0f38f7837ee7d4cda733442b0ef723e5d7664a5cd6d9b8e808d6cb4"
    sha256 cellar: :any,                 ventura:       "ab39755f672f5634c6555ae6822dae83813a50c1205a37774beb2e35d0552122"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a581a508009e4854e8790a0f246baaac0ec570945e331fc6aac65ab4a1a9a81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8277afbe297f7153901815514ad120e29b9ca67b891287c4ee133868d43b84f7"
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
