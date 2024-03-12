class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https://github.com/ShadowsocksR-Live/overtls"
  url "https://github.com/ShadowsocksR-Live/overtls/archive/refs/tags/v0.2.12.tar.gz"
  sha256 "17b99177a45270d24bdb81115e6e4efe2f37f8d206d969690a16a714c6043371"
  license "MIT"
  head "https://github.com/ShadowsocksR-Live/overtls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "37fe7c83512456b0b52e3a9f41e338d369088f71313f96c4ef8c16973d56d4ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa1871ed1c2db872e45feaf06abc70eafdf627426826175d30488f27eaa06909"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c077035ad882e5454ab46c2bda793e5dfdde93e52bd8591b1cf7842ab0b2c726"
    sha256 cellar: :any_skip_relocation, sonoma:         "5ff73c432c1c1c0ecdfe0c7172848d67feb0d471381083c2dcfe628d317d905f"
    sha256 cellar: :any_skip_relocation, ventura:        "3e35efdef00e25cd881e5df25079701056e254031134dd267d788e73f0319c6d"
    sha256 cellar: :any_skip_relocation, monterey:       "2a716ec2d43690d9712aa50115edcf73da2792b95ba3e783b9cb79b3d97720ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1061043de49f809f3294d6165a6346e80c5ef1616d1337df479f49fd015c5356"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/overtls -V")

    output = shell_output(bin/"overtls -r client -c #{pkgshare}/config.json 2>&1", 1)
    assert_match "kind: TimedOut, message: \"connection timed out\"", output
  end
end
