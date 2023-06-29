class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https://cobalt-org.github.io/"
  url "https://github.com/cobalt-org/cobalt.rs/archive/v0.19.0.tar.gz"
  sha256 "b6f18d72b22ebbad7cbaaff54a53a65c2e37de1356eb20588541fe5a2381fcc3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d3dfee072b977bf0cf4d8fbc23328ab327c568dbe9fa07765355a2b18f918b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99ab0dc602e261c0e4d76c494f89a0cca384e14fa3443ee19bf240c6964aeca9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cea7e332edc8d0b8d1ee002523020960fb328c2b05bfaa8d97c05ebf9fbb779d"
    sha256 cellar: :any_skip_relocation, ventura:        "f43753164106a755a61fe2626a47d2a70709302463029260f4fea51f53009990"
    sha256 cellar: :any_skip_relocation, monterey:       "742761af2433458c12837cabc1dffee119bd846c2b18623379cb3eb3f1e035a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "e3f3612d0a5fde600a98f87753567f82304387fe648cd5534185b8650cc829d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "698f125fc1a674410ab9ed0723326ff2e13ca82220c33a44f94489996423c89b"
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
