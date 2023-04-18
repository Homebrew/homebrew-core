class ChooseRust < Formula
  desc "Human-friendly and fast alternative to cut and (sometimes) awk"
  homepage "https://github.com/theryangeary/choose"
  url "https://github.com/theryangeary/choose/archive/v1.3.4.tar.gz"
  sha256 "6c711901bb094a1241a2cd11951d5b7c96f337971f8d2eeff33f38dfa6ffb6ed"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82ed2e1824a5e50d813e988e5e29bef7497a554d16765bc9499aeb413f7c293c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d57acf95592fce37b4300637b1c38989564d423de789b9fc624223f53de1c796"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f009a6ef6eb59df17bf53037237cb94c97d9f8a00e6a20de63d1952fde5fc56b"
    sha256 cellar: :any_skip_relocation, ventura:        "38fc4f96b6ed022b5d0a0066155e7aeb98e9b27bc95368a2b86dc98c49e13faf"
    sha256 cellar: :any_skip_relocation, monterey:       "eb7a88d2f6a7ea5dbc28602995baab358344289b590446d003e861fe3460f40f"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2fa7efa2e78068e948a7991caa5d2a92b346af9118c1e775405a1ae5fc80b61"
    sha256 cellar: :any_skip_relocation, catalina:       "da599fbd49ceee7815a21a1589b34f96d65efd6366d4ea286969f7b8efe0075c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1040d82ce5edb40b14f394947486e4cb07bfb4e1fdc0a387365a56debd5d07a"
  end

  depends_on "rust" => :build

  conflicts_with "choose", because: "both install a `choose` binary"
  conflicts_with "choose-gui", because: "both install a `choose` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    input = "foo,  foobar,bar, baz"
    assert_equal "foobar bar", pipe_output("#{bin}/choose -f ',\\s*' 1..=2", input).strip
  end
end
