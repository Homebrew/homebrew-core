class Krep < Formula
  desc "High-Performance String Search Utility"
  homepage "https://github.com/davidesantangelo/krep"
  url "https://github.com/davidesantangelo/krep/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "eea570981c9c24ade2c9bdebfd3ff144a5d4d30ba940e1bcf2f0e3355421886f"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abeeaebb1a7106686f09dd6cd76eb69c7aa572d89658810236476531ec284e06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e830eb2e2ed1a1886ecf0f296f06b72649624973c86f36b3f50736802463e124"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6cf7e9459a67144232b853108c03b92b07668b9640c8da92f45fd3f377f4eca"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2010747f0a200256ae54812a2043cfb7162e53158e4d63b74ed0c58e5e34612"
    sha256 cellar: :any_skip_relocation, ventura:       "fb742f1f5789a0ca58e285aebc035b3d4c8c7864e5be9b8104f2909f27938de3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ccc749c33a0d9108badfbd1c08ed20bfe09d4cfbebb1bf1addc40ac357209ecb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d952331a6b919b3fb98d9ff2071038d83de71d2242fe39a1672133fc6b726360"
  end

  def install
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
