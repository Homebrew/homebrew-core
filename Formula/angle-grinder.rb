class AngleGrinder < Formula
  desc "Slice and dice log files on the command-line"
  homepage "https://github.com/rcoh/angle-grinder"
  url "https://github.com/rcoh/angle-grinder/archive/v0.18.0.tar.gz"
  sha256 "7a282d9eff88bb2e224b02d80b887de92286e451abf8a193248d30136d08f4e0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aac94d72d3e7b33100dec2efdcf5e77678f81f424ab8d408ae2f044214c59f7f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "116d320e843719451ec991b97c2bb8c1aa2dea3623f387c866f12a718b512993"
    sha256 cellar: :any_skip_relocation, monterey:       "2b1e7b6bfef8586378fb75138e655a70717ccc2be44c9023421e7775a83e9bd2"
    sha256 cellar: :any_skip_relocation, big_sur:        "d94050232f3ce01eb97c1c36f79aa5d2734b9e4e25ede7d81e32eaaeca4a4db7"
    sha256 cellar: :any_skip_relocation, catalina:       "f41ebbb8078940ecc259ffac8451f70dc49df53a8d8f1fcafe4b02bc6723dcbc"
    sha256 cellar: :any_skip_relocation, mojave:         "73c19bc8e8e2697797e46ba6e6dd8a24deaa77a8059f0546bf29bffba5e0c8ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afe0edc8a8c223a9bfdbd0c515701e5103a4b4b9b168da747d991eb487dec25a"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"logs.txt").write("{\"key\": 5}")
    output = shell_output("#{bin}/agrind --file logs.txt '* | json'")
    assert_match "[key=5]", output
  end
end
