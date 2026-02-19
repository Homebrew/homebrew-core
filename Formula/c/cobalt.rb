class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https://cobalt-org.github.io/"
  url "https://github.com/cobalt-org/cobalt.rs/archive/refs/tags/v0.20.3.tar.gz"
  sha256 "e290f8d591bf0746e2aa62dc55176626150faa9e169747ccad34a50b8017a031"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "743a74faee578960d6aaa9b237c75f2df9c73c2c6f9672afdf03bda612da006a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11a1a1b380c2349f3cff0e0fdc7623346a0f59b67757c8df6fb0b3109a64671e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc3bc328521113a8cf15c0faaf49341b8400e40102a7dadbd2bb7eee073f6259"
    sha256 cellar: :any_skip_relocation, sonoma:        "b455407d80f6591ec2549165af5368847d80120cd14fcd6342d72e9e2d09ddc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52358e59a9280bf8482aab06eb8425053b8b34173dfc4e675b023a9c79aa9a07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb7ce664a338e2a4294b527040a97b5254e304ed82a01e9028dc789bd5f0f75d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"cobalt", "init"
    system bin/"cobalt", "build"
    assert_path_exists testpath/"_site/index.html"
  end
end
