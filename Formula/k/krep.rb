class Krep < Formula
  desc "High-Performance String Search Utility"
  homepage "https://github.com/davidesantangelo/krep"
  url "https://github.com/davidesantangelo/krep/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "76b0a9224b1e31aff49637c103b68e0d45d6b46456069e67e57b876a5c1ade59"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1979e322c19d736aa92e199a733c7945f38a588d87485c1890c056f18fda0520"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20211475afcc2c002ddd059295999f8b9167a4c99096a64af9c8a2921389372e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d9aa18cc347296fc88bf5567dac2dff8e13b3a5caa641c43ed053308d4a57cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f00ce366b9dbed2fdfca1d5848ea4864f02769445fc3f04bf3a54be8e3e8986"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bcc71c870fb68e62b4d2cf86d361901833358c2f2471ef2b58c5e9330f1087e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a8014f2fc90a1e7ed93eefafd11a5153f5f25b17bdadbfdaaa7452796df6d14"
  end

  def install
    # Version mismatch, remove in next release
    inreplace "krep.c", 'VERSION "1.2"', 'VERSION "1.3"'

    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.major_minor.to_s, shell_output("#{bin}/krep -v")

    text_file = testpath/"file.txt"
    text_file.write "This should result in one match"

    output = shell_output("#{bin}/krep -c 'match' #{text_file}").strip
    assert_match "1", output
  end
end
