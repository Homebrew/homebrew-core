class Headson < Formula
  desc "Head/tail for structured data"
  homepage "https://docs.rs/headson/latest/headson/"
  url "https://github.com/kantord/headson/archive/refs/tags/headson-v0.14.0.tar.gz"
  sha256 "de6b1a6c8dceaa176246e6364517b6c1a68773a4651b018522dd022fc08cee07"
  license "MIT"
  head "https://github.com/kantord/headson.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "090f82eafa57a13a217bb40bc76829092907454c509120e242656bc68d4a7a01"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "769e1eedf39f21fcc08a1b864de96015debff8f92fd150f63b524eabe3bf51b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "842bed29291970043c9af7997a36e29d532df28d35ba1b4ca9024a5aad952ffe"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d413c0af169a56ccee485e4f91316f97b691e9f34b02d5a53c3a721c1b0ce59"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4710c5ab0dd0989a323679232bdea638dc044967624b41e99072b13caf6c0d65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9afe4683a26dc082813419201cae29b96cec1da2483700306770d3ee4a4903b"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"hson", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hson --version")

    (testpath/"test.json").write '{"a":1,"b":[2,3]}'
    assert_match '"a":1', shell_output("#{bin}/hson --compact #{testpath}/test.json")
  end
end
