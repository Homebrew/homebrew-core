class Jaq < Formula
  desc "JQ clone focussed on correctness, speed, and simplicity"
  homepage "https://github.com/01mf02/jaq"
  url "https://github.com/01mf02/jaq/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "9b8587436be48b5791c8276573321a3d4f404e0dc77ea6503d05725a55edd266"
  license "MIT"
  head "https://github.com/01mf02/jaq.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1f221a72087e5d29553141796fa1a9ccbc7cedd3b603ac2f717caf20d1dbc08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10d51e61acc515284f578db8df2c7ab94cf432931fc5a8bb22b03660743abec4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9a96d328018fbbc726bee27c0ca539902e13f2c6579676e33a438c242f2f237"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfc04af8418a27e03da1a77f1ba193e5d7b8a4fb60cde064428707e6bb80daa5"
    sha256 cellar: :any,                 arm64_linux:   "460f49c6c2e4c2bcf6314d04821d4266c3ef03004a1bd88c2074c252d897719e"
    sha256 cellar: :any,                 x86_64_linux:  "89de760d1fa47a2d6ac248c835e2860188c82f18cb75c4a6438b18fc7c7c32ac"
  end

  depends_on "rust" => :build

  conflicts_with "json2tsv", because: "both install `jaq` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "jaq")
  end

  test do
    assert_match "1", pipe_output("#{bin}/jaq '.a'", '{"a": 1, "b": 2}', 0)
    assert_match "2.5", pipe_output("#{bin}/jaq -s 'add / length'", "1 2 3 4", 0)
  end
end
