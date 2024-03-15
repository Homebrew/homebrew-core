class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https://github.com/ShadowsocksR-Live/overtls"
  url "https://github.com/ShadowsocksR-Live/overtls/archive/refs/tags/v0.2.13.tar.gz"
  sha256 "5db1cba5f76f839e5f7d43354346e42d606ce5716534dcacaeda293dd41580b4"
  license "MIT"
  head "https://github.com/ShadowsocksR-Live/overtls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f15424e81d478cd434800831e93242f13b15ee8eb569876cc5ce1bc3d9eff043"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "faa9f8ae18ec203524fdc7b344ec0e87d831ec643d3eb28f232dbedd60593c76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b2e7f3addd04a20fb8fe89f90589a6863c662067aa9ae397fd9cba4ab1d0a0d"
    sha256 cellar: :any_skip_relocation, sonoma:         "02eef88e8642116eececbcd1745959b9a472a74e91880ebc783e81f21ad251b7"
    sha256 cellar: :any_skip_relocation, ventura:        "7c97f84e9f5607452f15339aadc9175ab26481c056d1c1994503288aabaeeecb"
    sha256 cellar: :any_skip_relocation, monterey:       "744778055d3f1296a06bcfb471e0cd0ac0f3a4a772d698dadf81524c9bb7ad6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c67f1d452af2436808d5d6d1c8c25a951614d0e103e59afca6988adb6765c706"
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
