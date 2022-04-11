class Melody < Formula
  desc "Language that compiles to regular expressions"
  homepage "https://yoav-lavi.github.io/melody/book"
  url "https://github.com/yoav-lavi/melody/archive/refs/tags/v0.14.3.tar.gz"
  sha256 "812f058c60eba281758288d14f7a605d5684995b12a5598da73cb49d840eeda4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f25c8573b97feee67367b12b5361570a7c18660d2eee2338aff049e0ddc2fabb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98c9676a347c381603ec1a2f75ed02b13ea88f8d33c9c3aedfd1577005b10e63"
    sha256 cellar: :any_skip_relocation, monterey:       "61673361ee72b1e643b5e4656fa2e6fba57b939879c4c8104d93dd7deada55d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "83acdd5170a9d6c7d3ce666a0fa893e4260f9736f6d5ea3af8bfb6d2cb6767b5"
    sha256 cellar: :any_skip_relocation, catalina:       "7a4b6786f336d658edff893980d29407d3f90d5308203b1ab2a5267973a901c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54bb7ac7a139fde0d3461c17c6aeb4a70560b4d7c70a556a5dd20ec055ee30d9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/melody_cli")
  end

  test do
    mdy = "regex.mdy"
    File.write mdy, '"#"; some of <word>;'
    assert_match "#\\w+", shell_output("#{bin}/melody --no-color #{mdy}")
  end
end
