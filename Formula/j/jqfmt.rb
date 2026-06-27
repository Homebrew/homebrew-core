class Jqfmt < Formula
  desc "Opinionated formatter for jq"
  homepage "https://github.com/noperator/jqfmt"
  url "https://github.com/noperator/jqfmt/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "5435c3166921ea103513d516c4d56ee00755d6b0b798f3edbdabfc06a1d98268"
  license "MIT"
  head "https://github.com/noperator/jqfmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "efccec434c604682d35d22fb555c76a6be98d32061659490e347cfc9899d4fd9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efccec434c604682d35d22fb555c76a6be98d32061659490e347cfc9899d4fd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efccec434c604682d35d22fb555c76a6be98d32061659490e347cfc9899d4fd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba048efdbe947e7ad2d55b70950cf0aa2f240de0173d53a3ba16a247619b3cc5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "268a458ea1f3b37a4216d39e20cc76d75867e9014082a6fa17671affd91861b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58e02aaa04a270883608b5bc66d032c99ef59d64f1806caa45f49db7637f0954"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/jqfmt/main.go"
  end

  test do
    input = "{one: .two, three: [.four, .five, [.fivetwo, .fivethree]], six: map(select((.seven | .eight | .nine)))}"
    expected = <<~JQ.strip
      {
          one: .two,
          three: [
              .four,
              .five,
              [
                  .fivetwo,
                  .fivethree
              ]
          ],
          six: map(select((.seven | .eight | .nine)))
      }
    JQ
    test_file = testpath/"test.jq"
    test_file.write(input)
    no_trailing_spaces = ->(subject) { subject.chomp.split("\n").map(&:rstrip).join("\n") }
    assert_match expected, no_trailing_spaces.call(shell_output("#{bin}/jqfmt -ob -ar -f #{test_file}"))
  end
end
