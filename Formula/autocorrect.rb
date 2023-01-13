class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://github.com/huacnlee/autocorrect"
  url "https://github.com/huacnlee/autocorrect/archive/v2.5.8.tar.gz"
  sha256 "9a06dadf9e5d4032e81edb44fd6e0b61e70bcd01fc094b9e2b4861d8cb03bcea"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41415f2646eefe3c78501f7d4e428e69d1dbde3bf5fdb932b35cac5a0b8ad369"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3393c7a2323866f198227a1d99626c285ca485ae7d551caeee72c6f2ab105931"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cee5ac39e52af24a6e9fe027837492f363a5be9dc9995596594aee946df5dde2"
    sha256 cellar: :any_skip_relocation, ventura:        "d37e311aadeab44e965eb160c163632d7f587fda23ae83bc749ef57f9c84288f"
    sha256 cellar: :any_skip_relocation, monterey:       "8dcd6e31b208b5db5540f65146761844555bcad92417cf3eb8089fdf00218fab"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a64eb46e19170811351ed973e966013c67561c17aaf25fada8e0dd495e3fbe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f203efbabb90cc82406cd720a1e95d1489b004fab551e05f3fd0f901d7a270b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "autocorrect-cli")
  end

  test do
    (testpath/"autocorrect.md").write "Hello世界"
    out = shell_output("#{bin}/autocorrect autocorrect.md").chomp
    assert_equal "Hello 世界", out
  end
end
