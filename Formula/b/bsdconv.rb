class Bsdconv < Formula
  desc "Charset/encoding converter library"
  homepage "https://github.com/buganini/bsdconv"
  url "https://github.com/buganini/bsdconv/archive/refs/tags/11.7.tar.gz"
  sha256 "c7ce9b7fd5a80f5da36dfbf2b49ca86f67088b006d26f708fcc1112b7c1feafc"
  license "BSD-2-Clause"
  head "https://github.com/buganini/bsdconv.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "5575183c423948462b572cf268e94ee0017a849807d0f2ee4f50d121343081c6"
    sha256 arm64_tahoe:       "aac51740b043500e07a2cc52122aa02afa449eea3f015cb4cf1c3ee8ca55c0ba"
    sha256 arm64_sequoia:     "3d4c10c2d81097ebcdd0b6ce6626fcbcca09e824f4c0233f2ae0287f5c3329e5"
    sha256 arm64_linux:       "794b8f437ad88d9363545192960d2e330c6454586a5c7620730bc0623f75b7b4"
    sha256 x86_64_linux:      "15695e87a50300769dc59b25751ddcdb2ecd4289ffbcaccf54229865f39209c2"
  end

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    output = pipe_output("#{bin}/bsdconv BIG5:UTF-8", "\263\134\273\134", 0)
    output.force_encoding("UTF-8") if output.respond_to?(:force_encoding)
    assert_equal "許蓋", output
  end
end
