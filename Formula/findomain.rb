class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/findomain"
  url "https://github.com/Edu4rdSHL/findomain/archive/4.3.0.tar.gz"
  sha256 "e0a7cf999ee7b467641a4b2fe505d43679e3c0f53cde103ae0ef37e73fd20cd5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f0b03dad6c61a5dbaad9270b9d9503055cb8beb598d26e4aa538ae7f1c7d2ac2"
    sha256 cellar: :any_skip_relocation, big_sur:       "56903a316a57a44b0d8805581a1862e876166d2bed9faff82da9b7ebbd84b357"
    sha256 cellar: :any_skip_relocation, catalina:      "ba529408cd4b1b2751a06633ab3bdfbf4a9a949423c7936866f1db425d2a9aef"
    sha256 cellar: :any_skip_relocation, mojave:        "fd3fd37d93ce490f15777ff7ffdfeaed7a68790e0ce4bc3ba265da45b25f9bf5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
