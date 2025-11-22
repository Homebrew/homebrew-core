class Gauche < Formula
  desc "R7RS Scheme implementation, developed to be a handy script interpreter"
  homepage "https://practical-scheme.net/gauche/"
  url "https://github.com/shirok/Gauche/releases/download/release0_9_15/Gauche-0.9.15.tgz"
  sha256 "3643e27bc7c8822cfd6fb2892db185f658e8e364938bc2ccfcedb239e35af783"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/^\D*?(\d+(?:[._]\d+)+(?:[._-]?p\d+)?)$/i)
    strategy :github_latest do |json, regex|
      json["tag_name"]&.scan(regex)&.map { |match| match[0].tr("_", ".") }
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "3938d61ea6df0e0839af39a7f2c11fe15eb5b626ffcf6d83c9a9c1b861c17ab3"
    sha256 arm64_sequoia: "a2389dca53067a6108ce35ef85c2a998f94ecf2263fe7229fd32af2080876f5b"
    sha256 arm64_sonoma:  "1bca898ca8fc5a742e12d291fd8a4419337813bddeb49d43e4733a7af176d23c"
    sha256 sonoma:        "0578f389e9f10c66cf413a59663baf0c64c4ae33430adbbcaf66878d06aa4d3a"
    sha256 arm64_linux:   "74235050e6be7d472ae7f41135aae668cc04287df76a7be484ffb1385c457082"
    sha256 x86_64_linux:  "8b7778c8b95093b9f06adc50af12f89ff7b5125b45fd94bac0e7639dcf3fce30"
  end

  depends_on "ca-certificates"
  depends_on "mbedtls@3"

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  def install
    system "./configure",
           *std_configure_args,
           "--enable-multibyte=utf-8",
           "--with-ca-bundle=#{HOMEBREW_PREFIX}/share/ca-certificates/cacert.pem"
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/gosh -V")
    assert_match "(version \"#{version}\")", output
    assert_match "(gauche.net.tls mbedtls)", output
  end
end
