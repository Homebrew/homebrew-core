class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/shssoichiro/oxipng"
  url "https://github.com/shssoichiro/oxipng/archive/v5.0.0.tar.gz"
  sha256 "2a3197c9a0afdd91967f9981da7ce684b40eced4191c26c167b3c214a7cfd9ec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "264f1ab92ac0dc6595d395a52fb32c0fe0711a9592d80d2e7c00584ce5f15e63"
    sha256 cellar: :any_skip_relocation, big_sur:       "9de887c99b435d7f3c8a5567b0ea9bd68b2eb3a9e7095fc6f68261325aeefc4f"
    sha256 cellar: :any_skip_relocation, catalina:      "84295509fae9c40435518c4fa5ba2e2b8ed45b271e70a2ecefb21de5c091e177"
    sha256 cellar: :any_skip_relocation, mojave:        "9278cd1e4ce418514c4c34b3898371c360ed770ed583c6b9acfbd39c447c5103"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2c295bcc7da7fbd8c82e2a53b1826fb0e8b408c7a3d2809b9abd997e7c01c24"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"oxipng", "--pretend", test_fixtures("test.png")
  end
end
