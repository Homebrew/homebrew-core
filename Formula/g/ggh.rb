class Ggh < Formula
  desc "Recall your SSH sessions"
  homepage "https://github.com/byawitz/ggh"
  url "https://github.com/byawitz/ggh/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "1adf81aec62040233154843dd18cf575c9485a10d4f46c475708474536422b1b"
  license "Apache-2.0"
  head "https://github.com/byawitz/ggh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f19e7aab53fda165524a48499bc2426204ecbca9012a1f860c5ca6f624f29338"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f19e7aab53fda165524a48499bc2426204ecbca9012a1f860c5ca6f624f29338"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f19e7aab53fda165524a48499bc2426204ecbca9012a1f860c5ca6f624f29338"
    sha256 cellar: :any_skip_relocation, sonoma:        "f461df86eb13b905275e1329d1938686b363b4ad2521b643109ebd2338fcccfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b0cd2a8832adfb19727d4a81750fdfcd1e1268fb3ca4804b4e616d996f0add5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d17c99fe36147ed032691e97d9fdc12073ff980a93a5a932fbfe07e315babb65"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "No history found.", shell_output(bin/"ggh").chomp
    assert_match "No config found.", shell_output("#{bin}/ggh -").chomp
  end
end
