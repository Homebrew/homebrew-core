class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https://cobalt-org.github.io/"
  url "https://github.com/cobalt-org/cobalt.rs/archive/v0.18.3.tar.gz"
  sha256 "32350ef91a0c1dd81b75e8eb94f5a591ca91bd35d1a6d97622996b1086d5ced2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87da04debee4a55ff30693b1ebbeb403443a87cda42d359e9ccd62ae53143299"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a9dfd028369762a67366ad1fa19beef56e89eaab849e3e3cb47fca0f2746561"
    sha256 cellar: :any_skip_relocation, monterey:       "be719e69f1d66c3e979d3a3136b5d785e462b01bd6ec3027732a7af1bb8f1773"
    sha256 cellar: :any_skip_relocation, big_sur:        "4328bc511531d9dbb0f730623eb0ec57caf7934123e8d3aadacd5871d698c0a6"
    sha256 cellar: :any_skip_relocation, catalina:       "a86b37947f31611c32b99f9529ddc5cfc88caf503d340069f83ba609bccfc784"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35b816a188a5e3b868666a320da2955141f35a86eb3ccd944e6ac77b981007c0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"cobalt", "init"
    system bin/"cobalt", "build"
    assert_predicate testpath/"_site/index.html", :exist?
  end
end
