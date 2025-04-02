class Krep < Formula
  desc "High-Performance String Search Utility"
  homepage "https://davidesantangelo.github.io/krep/"
  url "https://github.com/davidesantangelo/krep/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "3a93ba3c84199329342a20377180e949162363418c073c8c28e8c78617c96fec"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d24d956157b3980d291edd5e071626edd7bfa74876c77d7a001dc7e8f94d9731"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17417a2b087e8ba6371535c958b5087c56b33c49a05212be3458623670129f83"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "33ce4160bbf2464f48993eaafbbecb11f994209a66fd31de32a16e8987695e33"
    sha256 cellar: :any_skip_relocation, sonoma:        "db8dfa09c15cc0e9f7128452bd16f516a22eef5680927ba46efe1e6c1c38275b"
    sha256 cellar: :any_skip_relocation, ventura:       "ee641f2271a4377d73ca5682c89726634b49a050381eb96c1a39ff1f56bdf9ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ba4644a0417b35d156bc03d8c0bdb4b2267fbc7b279afee968e7132ff142881"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a45ea62533ddd00653d0303178f5bebe7feb4f43bc85682723ca43512bf6beab"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/krep -v")

    text_file = testpath/"file.txt"
    text_file.write "This should result in one match"

    output = shell_output("#{bin}/krep -c 'match' #{text_file}").strip
    assert_match "1", output
  end
end
