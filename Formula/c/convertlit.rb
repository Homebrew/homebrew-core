class Convertlit < Formula
  desc "Convert Microsoft Reader format eBooks into open format"
  homepage "http://www.convertlit.com/"
  url "http://www.convertlit.com/clit18src.zip"
  version "1.8"
  sha256 "d70a85f5b945104340d56f48ec17bcf544e3bb3c35b1b3d58d230be699e557ba"
  license "GPL-2.0-or-later"

  # The archive filenames don't use periods in the version, so we have to match
  # the version from the link text.
  livecheck do
    url "http://www.convertlit.com/download.php"
    regex(/href=.*?clit[._-]?v?\d+(?:\.\d+)*src\.zip[^>]+>\s*?Convert LIT v?(\d+(?:\.\d+)+)/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0cfe39c84460ec28081f4e2fa92771253085837c8986d9d3121c573eb1a6a072"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af81e33973b458225160387d713ab4646496719b4c0a3ae064dccf92c7e3efbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0df27834c193ce4b6f3d17a63c072818bd667f2d98b653f166c024d3bdafbdb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "723db1f95f54e5f9003305056b3e67c5d2e6eb424fb18cc4e366a2dbe53756d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "061b39d2c0b09a6bd68c6f1219b396e558cd4cbe8dcbaf64968079bb2c2a9253"
    sha256 cellar: :any_skip_relocation, ventura:       "47c22a8704d183095db27702edb6dbe248f4cbf88b3aeb788ea2686656ddf05a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28b8504282e33b2b346b2bc88313fcaac3d9525327d576341adb40b7da58b0af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9e0dbeb09435b5d6c8a8f0e728d345185e14bb1bd4a799c05a1cefde6938046"
  end

  depends_on "libtommath"

  def install
    # Workaround for Xcode 14.3
    %w[
      lib/Makefile
      clit18/Makefile
    ].each do |file|
      inreplace file do |s|
        if DevelopmentTools.clang_build_version >= 1403
          s.gsub! " -Wall ", " -Wall -Wno-implicit-function-declaration "
        end
      end
    end

    inreplace "clit18/Makefile" do |s|
      s.gsub! "-I ../libtommath-0.30", "#{HOMEBREW_PREFIX}/include"
      s.gsub! "../libtommath-0.30/libtommath.a", "#{HOMEBREW_PREFIX}/lib/libtommath.a"
    end

    system "make", "-C", "lib"
    system "make", "-C", "clit18"
    bin.install "clit18/clit"
  end

  test do
    (testpath/"test.lit").write("fake .lit file content")
    (testpath/"exploded").mkpath
    output = shell_output("#{bin}/clit test.lit #{testpath}/exploded 2>&1", 255)
    assert_match "LIT FORMAT ERROR: File is too small", output

    assert_match version.to_s, shell_output(bin/"clit", 255)
  end
end
