class Nixpacks < Formula
  desc "App source + Nix packages + Docker = Image"
  homepage "https://nixpacks.com/"
  url "https://github.com/railwayapp/nixpacks/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "f1f93c79690d8d6dd07fe9726861ffcdcf4f990c0eab4a4704d3a1b55b910bff"
  license "MIT"
  head "https://github.com/railwayapp/nixpacks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efef649dd08450a764c16f0bc6fa87cb634814f80a51bba6cf5e5f9935dbceb5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e618d63d995facd56c74f4e0a141c455f8225f0b22e653eefb4d659bf5fb345"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ba6fbfacfe6b10e5de5b6fc7e7e05dedb12c0208418bfc195fc69c39a6a83a8"
    sha256 cellar: :any_skip_relocation, ventura:        "19c452380443080aa7844c7027b10a9027ff2d1493178a8efda0442438626048"
    sha256 cellar: :any_skip_relocation, monterey:       "7eedfad759b582d459cb1d6987040e4f8f814f050c857c265bf1398fb0645908"
    sha256 cellar: :any_skip_relocation, big_sur:        "0cb320416675f4e4c4cc558eb89fd6a692ce051bbfbcac44c0852f45a6ccde0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3d7d6c5b512526c2296b12df1a94e2c395306278ade72d949149c8ddf405a77"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/nixpacks build #{testpath} --name test", 1)
    assert_match "Nixpacks was unable to generate a build plan for this app", output

    assert_equal "nixpacks #{version}", shell_output("#{bin}/nixpacks -V").chomp
  end
end
