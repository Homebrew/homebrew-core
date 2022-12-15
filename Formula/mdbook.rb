class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/v0.4.23.tar.gz"
  sha256 "50c3b575ef77a4a35e294e1bf2e47ffc2b2ff757c9d4e9e9f08d84a79efa4f12"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f79c18d2d18b0a81807d1cd9be69bf479474cfdfca3be17ad64560ddf4a4da5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e259058acbee1b609088bbe23da21e70c7c5364c5cc550ee3518ec059f245a5e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ca65f74cf93287d9d5e37cbebcdd0cfa84d496113cf1f41a45ccbce451f74c8"
    sha256 cellar: :any_skip_relocation, ventura:        "bafe94ad5c4caf51af7a8afdbd87ad6d423a3e46ea0e035028e39d9855e2da37"
    sha256 cellar: :any_skip_relocation, monterey:       "0fd0a9be158e78581427048cd7023ec87f22dbc51a84f06f1ee46fe9d446b8b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a37df6028e3ce17d6614fd002a4acbc4368544ddac6a6b616f219d47217496f"
    sha256 cellar: :any_skip_relocation, catalina:       "d17a284cf020dccb3dc9654121a256a497cce024be545cfd3f241ac9ca8e2fd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d21b9bbf9828211c8a96c2de3261047e591128aec8f609302f4c36c0a1b1905"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # simulate user input to mdbook init
    system "sh", "-c", "printf \\n\\n | #{bin}/mdbook init"
    system bin/"mdbook", "build"
  end
end
