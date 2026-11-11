class Chkrootkit < Formula
  desc "Rootkit detector"
  homepage "https://www.chkrootkit.org/"
  url "ftp://ftp.chkrootkit.org/pub/seg/pac/chkrootkit-0.60.tar.gz"
  mirror "https://fossies.org/linux/misc/chkrootkit-0.60.tar.gz"
  sha256 "bf43d227f99d6d9dd28c629a4e5f85d6a5de3cf83010feba5a04f4e1c5c5de28"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?download[^>]*>chkrootkit v?(\d+(?:\.\d+)+[a-z]?)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e0c59eb19095a5caa551fd9556edde59227317814921560526d90d709c650f94"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f7dfbdc5f745b2a66bbd345dc028c0d57a08dc2aa9b4067a35d7567692d17246"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fa5e193ab4b1a2bb28299ae2d89b96b22eeec68a2f63f312108fd2074461a779"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "34657f62987ff4a1fa3097a336fd102c095d0a911ac9854d39e9afe62b4971e8"
    sha256 cellar: :any_skip_relocation, sonoma:            "0b9645b0781169092d043005462f7b2e181b897df6815a11ddeaceb1aa139a58"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5f5f417e6d16ded63588606860a06f97d548cd331b0f5528f985a12df76a2363"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6414b28b97256b17b3c61214abc02f07d5613e42efbc26cb881620a12f33f29d"
  end

  def install
    ENV.deparallelize

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    # Remove prebuilt Linux binaries shipped in the release archive.
    system "make", "clean"
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}",
                   "STATIC=", "sense", "all"

    bin.install Dir[buildpath/"*"].select { |f| File.executable? f }
    doc.install %w[README README.chklastlog README.chkwtmp]
  end

  test do
    (testpath/"sample").write "\0homebrew\0chkrootkit\0"
    assert_equal "homebrew\nchkrootkit\n", shell_output("#{bin}/strings-static -a sample")
  end
end
