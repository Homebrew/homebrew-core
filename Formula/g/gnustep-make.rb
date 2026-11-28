class GnustepMake < Formula
  desc "Basic GNUstep Makefiles"
  homepage "https://www.gnustep.org/"
  url "https://github.com/gnustep/tools-make/releases/download/make-2_9_4/gnustep-make-2.9.4.tar.gz"
  sha256 "b956b89d1c1f7aac57da8a20058058b112ed8cf929807ea9f71a47163010e5dd"
  license "GPL-3.0-or-later"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^make[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("_", ".") }
    end
  end

  bottle do
    manifest_sha256 "d6a418e84bfbd4ef2631360cdc24420b7322acdf1044b42a3f55adb30c26463f"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b4338654fa461970005f0ff189cd7d470b9237133de3c9740d49479ea3029c7c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8a64830d2abff7d2b3c03cca7ad6df97dc627968be3550b3ee60f0760bb8862a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e8115200b27a1ac991c92625bb770f4234001a6b7bed8f1a6fa4e94ab5ada0a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4104848ff59ec343795f5eb9cb08fd45acdc106da8220c3e75af7e1bde350743"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "471eef90f0ee1b37aa935318237eb86da156ad96e196873099e059bc45f2ccfa"
  end

  deny_network_access!

  def install
    system "./configure", *std_configure_args,
                          "--with-config-file=#{prefix}/etc/GNUstep.conf",
                          "--enable-native-objc-exceptions"
    system "make", "install", "tooldir=#{libexec}"
  end

  test do
    require "shellwords"

    cc = File.basename(Shellwords.split(shell_output("#{libexec}/gnustep-config --variable=CC")).first)
    assert_match(/\A#{Regexp.escape(cc)}(?:-\d+(?:\.\d+)*)?\z/, File.basename(ENV.cc))
  end
end
