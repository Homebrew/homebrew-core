class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/v0.20.0.tar.gz"
  sha256 "360d0ac92ceac3a23f91193709aeb23225e548ad710ad04c0875ff158099f954"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b81fa3e68d36ed8b5464b576e9fe4f2b29936d36f7799b2e8c6851d4c010fee4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbe137d4ffdda5baa1e532fb9bed7846d48955784dda64ba71fcb2a5bb6c2e78"
    sha256 cellar: :any_skip_relocation, monterey:       "2979beb9f05c816ee2c56073d5f3968f3d231116bf791064dff7fbdfe76eaf9a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2b447422ce6a2e8107507c90ffcda5586630652ad7698233fc4c9c4b28dfb9d"
    sha256 cellar: :any_skip_relocation, catalina:       "43358f38198accc1ff0235bb2722481bf10cdc0682531d0b70970d3756356506"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "668f54b6186fda669d9dcfd47f6221ac8299e936ff2b3f446d092049a9759ff0"
  end

  depends_on "rust" => :build
  depends_on "erlang"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "compiler-cli")
  end

  test do
    Dir.chdir testpath
    system bin/"gleam", "new", "test_project"
    Dir.chdir "test_project"
    system "gleam", "test"
  end
end
