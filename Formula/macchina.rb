class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/v6.0.6.tar.gz"
  sha256 "da77e1899b13e4612b5ca6a22e8e266beabc734153e7a59c7c8b82c142510435"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d5a96804eb206cf1923ac230f1258b1a1ec20f81e52a480c14ac222bf6e2d88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abbf52a7476dcb57e761dbb49a0f0c8766b515efd0ea83d23ff583ef411d0800"
    sha256 cellar: :any_skip_relocation, monterey:       "a4148c587921ec6a4c63c91634034e35d0c11a8da92d79832638e0e01113e35b"
    sha256 cellar: :any_skip_relocation, big_sur:        "f23940e164823b1993f0c975196649ae679086c6f808a1b9483a6597d054c5db"
    sha256 cellar: :any_skip_relocation, catalina:       "97d1220355a8197af4ef37309c4d912c4b681150ed7b7b5c7d519f37aeb0b692"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba572e1a14126edc0eafde80aab5aa1e32cfa5c806a9674fa9a582e589e6c647"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end
