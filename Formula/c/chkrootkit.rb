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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ecdd225da39eb887395d57428b3c20ed56ba3c8642ddb82b175cab6b054d73d8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dd6e47897737217c4f55a31317b69f47acb3a4a8c101e88acd087c9904f36e8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "70f2394b2ef2303faf7a2cb5b117e4b14876edcbe8403941ce30c0280a81174d"
    sha256 cellar: :any,                 arm64_linux:       "142c2f512e850f2305ef89191a1396e3a97474c6c0107dbd73920ee30055ab4d"
    sha256 cellar: :any,                 x86_64_linux:      "eb514c894f14385a006309cc4c1fef86fe76a893f8b73ec2fd98b88ca843d5e8"
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
