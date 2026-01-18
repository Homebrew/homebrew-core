class NumUtils < Formula
  desc "Programs for dealing with numbers from the command-line"
  homepage "https://suso.suso.org/xulu/Num-utils"
  url "https://suso.suso.org/programs/num-utils/downloads/num-utils-0.5.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/n/num-utils/num-utils_0.5.orig.tar.gz"
  sha256 "03592760fc7844492163b14ddc9bb4e4d6526e17b468b5317b4a702ea7f6c64e"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?num-utils[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, all: "9d5185fbab175569c61a97393d00d32ed091c41c2ea6fc16b2d80e1d77b81106"
  end

  depends_on "pod2man" => :build

  uses_from_macos "perl"

  conflicts_with "normalize", because: "both install `normalize` binaries"
  conflicts_with "argyll-cms", because: "both install `average` binaries"

  def install
    %w[average bound interval normalize numgrep numprocess numsum random range round].each do |p|
      system "#{Formula["pod2man"].opt_bin}/pod2man", p, "#{p}.1"
      bin.install p
      man1.install "#{p}.1"
    end
  end

  test do
    assert_equal "2", pipe_output("#{bin}/average", "1\n2\n3\n").strip
  end
end
