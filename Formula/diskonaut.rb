class Diskonaut < Formula
  desc "Terminal visual disk space navigator"
  homepage "https://github.com/imsnif/diskonaut"
  url "https://github.com/imsnif/diskonaut/archive/0.11.0.tar.gz"
  sha256 "355367dbc6119743d88bfffaa57ad4f308596165a57acc2694da1277c3025928"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c286351912c9d217e5c1d5cce7ee3222d3b55558f114cc59f50c98f56ff0d2b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "607b84f58d50e14ca2bdac82a0d53f7e701a6673ee6d63d20b5a3c85e7232ee3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27276ff079b4e62db5a6bd19b0e76d302c535ba6e367e760350a5168b15e35d2"
    sha256 cellar: :any_skip_relocation, ventura:        "c92c31afbe56de87bc3be623a4df2f07c0da1f211b7aeaad205c1e251c36c94e"
    sha256 cellar: :any_skip_relocation, monterey:       "ca2ead79bbdce41e8b1a5b2ded6422c27a71e0c9ccc119d4b3eb6ca2697a5e8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "4db6857d320a4d03ab6a2df8de8604d6918ffce4aa6b4f36951bddd94656aaa3"
    sha256 cellar: :any_skip_relocation, catalina:       "8e6ed47ccdb395b2f461a1e12376ee463bbdca05e572fe2aa33dba49df81f3fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af43639e44daac484d6b43f33400310a21abf9632c85c198d41aad2edd34a0bc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = pipe_output("#{bin}/diskonaut", shell_output("ls"), 2)
    assert_match "Error: IO-error occurred", output

    assert_match "diskonaut #{version}", shell_output("#{bin}/diskonaut --version")
  end
end
