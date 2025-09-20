class Msedit < Formula
  desc "Simple text editor with clickable interface"
  homepage "https://github.com/microsoft/edit"
  url "https://github.com/microsoft/edit/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "e4ba6ff1bfecfeff2492306f5850c714bf50ffdb3cc3bb5be3aa987289f240fe"
  license "MIT"

  depends_on "rust" => :build
  depends_on :macos # due to test failure on linux

  def install
    ENV["RUSTC_BOOTSTRAP"] = "1"
    system "cargo", "install", *std_cargo_args
  end

  test do
    # msedit is a TUI application
    assert_match version.to_s, shell_output("#{bin}/edit --version")
  end
end
