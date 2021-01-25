class NumUtils < Formula
  desc "Programs for dealing with numbers from the command-line"
  homepage "https://suso.suso.org/xulu/Num-utils"
  url "https://suso.suso.org/programs/num-utils/downloads/num-utils-0.5.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/n/num-utils/num-utils_0.5.orig.tar.gz"
  sha256 "03592760fc7844492163b14ddc9bb4e4d6526e17b468b5317b4a702ea7f6c64e"
  license "GPL-2.0-or-later"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "50236cf7c8b791ba5663085c16837419d9bdc9452d64ba2f81936094f9f53592" => :big_sur
    sha256 "1dd2bf76cfa7fe7266662d3ffa199ef21478dce933958dba08d51adddcee7a13" => :arm64_big_sur
    sha256 "b8aac296053a3fd6811ffdf85cb6f133174e4df5bd47318c02ad1f7298366fd6" => :catalina
    sha256 "476a96d60faaf281b704e6a137a0b4e03bd708e51f07ae97940f7efdba693ebb" => :mojave
  end

  conflicts_with "normalize", because: "both install `normalize` binaries"
  conflicts_with "crush-tools", because: "both install an `range` binary"
  conflicts_with "argyll-cms", because: "both install `average` binaries"

  def install
    %w[average bound interval normalize numgrep numprocess numsum random range round].each do |p|
      system "pod2man", p, "#{p}.1"
      bin.install p
      man1.install "#{p}.1"
    end
  end

  test do
    assert_equal "2", pipe_output("#{bin}/average", "1\n2\n3\n").strip
  end
end
