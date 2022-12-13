class Pomsky < Formula
  desc "Regular expression language"
  homepage "https://pomsky-lang.org/"
  url "https://github.com/rulex-rs/pomsky/archive/refs/tags/v0.8.tar.gz"
  sha256 "c9d1e34e37b2f09e576f819fabd63c99953c49e050a67112d1c988ab6ed480d9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/rulex-rs/pomsky.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2ad385fcc566b4350f9997bdead5f424bd69b20197790b9eb7173fbf276a3e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4714400d4aa1dcbc25f615307a14261f2c9ba9b8ab784ee57c3fbeb41b48ab0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68875a5e6f05fbbbb9266c37bcec86c57bf6114f05d592922acfc86faf0aa6bf"
    sha256 cellar: :any_skip_relocation, ventura:        "c279770f8cd5acc209b1c377f44c84372e4e08053d15271743b31bd790369fd6"
    sha256 cellar: :any_skip_relocation, monterey:       "63fd4ffdf988addb5f86b3264834224860466817beebac49519df73bc8beb447"
    sha256 cellar: :any_skip_relocation, big_sur:        "54ba3679a2457afe15dd419bdf257d5e7b37bf02e14b0fa85ebca9b9c2c0ea5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa903b95850e748107dda93da237315f1ea8a09c3c2c92779cf7dc8b18ddce9a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "pomsky-bin")
  end

  test do
    assert_match "Backslash escapes are not supported",
      shell_output("#{bin}/pomsky \"'Hello world'* \\X+\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/pomsky --version")
  end
end
