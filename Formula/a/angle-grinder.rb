class AngleGrinder < Formula
  desc "Slice and dice log files on the command-line"
  homepage "https://github.com/rcoh/angle-grinder"
  url "https://github.com/rcoh/angle-grinder/archive/refs/tags/v0.19.6.tar.gz"
  sha256 "f76e236f0825ca3f0b165e37d6448fa36e39c41690e7469d02c37eeb0c972222"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98723fe85d178aac89df81a680eb6219bfb4559d4f5e2c78d7b09753e64b7ce3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "280e3f3eeb588c1af385fad6a05e08f5e6091f8114c268d56bba319a61800c92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d56a1aa983b7e82416a161f67ba167e0621adaa77f105c54d6718d67077ea0ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a50e61175718bb7bf7308a14048d490ddf3e7da8fe757f5155468b997dd7d121"
    sha256 cellar: :any_skip_relocation, sonoma:        "2159b170bb90518e07ae0e8cfc5d3600c15d9289c88845ca2e9891f5618f731e"
    sha256 cellar: :any_skip_relocation, ventura:       "558f1dcc5e0109898a9e49511cfda872245e9c4cdf42d0785214c197f8b04e2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0ee850784501fcc08b3a8e5b04b0ed884d15cd5563d5fade0e1bfcbcdbc1cc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "881ad5857fabe8dc722b466099b20ce47b582f7508612419425af047e73c2ba5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"logs.txt").write("{\"key\": 5}")
    output = shell_output("#{bin}/agrind --file logs.txt '* | json'")
    assert_match "[key=5]", output
  end
end
