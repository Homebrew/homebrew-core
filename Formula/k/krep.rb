class Krep < Formula
  desc "High-Performance String Search Utility"
  homepage "https://github.com/davidesantangelo/krep"
  url "https://github.com/davidesantangelo/krep/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "7441d790fbf23b71f32421bb40787a8742fe47d2deb15ad4310c4eb90af0e78c"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdacc0c2fb0d962bbbbfc5bf483d55dd9d41d662dc780654ab57bb09a566dfe9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35f03f6510333a575a1ecb69e9b067ebef7c4686e111719684f811b1fc4f7437"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e92e7299a72147ea14e0619c70a1bb218f418717fe6005dd5e82e810179defb"
    sha256 cellar: :any_skip_relocation, sonoma:        "717967e39d3db728fe43d9c204e606887ae68218458784ce97e34d37d42378fb"
    sha256 cellar: :any_skip_relocation, ventura:       "84e9a84d2bf924669fc3fdcecd29a65d1edb1d664dbdc12ba0e196b67857c15f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78bcbcc9a349027dda90732203bf8b2ebe7c99e134552cdc81ea50d7a3c6e4f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd99985cbd462df66da859bfd04a313edbb928bede91d33c46040761a3b5520a"
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
