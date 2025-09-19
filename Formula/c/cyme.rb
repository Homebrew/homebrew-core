class Cyme < Formula
  desc "List system USB buses and devices"
  homepage "https://github.com/tuna-f1sh/cyme"
  url "https://github.com/tuna-f1sh/cyme/archive/refs/tags/v2.2.5.tar.gz"
  sha256 "48f776b9d820429a8060c2d2f89af589a42dbc5e85ddd7a5af7823a71deb32e2"
  license "GPL-3.0-or-later"
  head "https://github.com/tuna-f1sh/cyme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0605c712d0e35028157f7c75b179c70ffdc0325376ca668d7e5442b2f14d8e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20dcc1834e111dbb5ed8a165b1cde8e32058ab3a6656af92b2c6a6851ab66913"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d226039bfa697f5e588e5c248f756e8a94b9b4b6f852c6cf38ffa72edf5b4de"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b77342fde9ac3f612c20e4478c3ebea1e346e0d95126549e08796fb9937f9f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89ba23ca9cdacebc3f7873560afb99f64f01adea6927ad2f48ea33cc81eae92b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8169733c5f6efe6fbbcb423bed2b54df197fc0afb9cdac8a2e11383d287ae138"
  end

  depends_on "rust" => :build
  depends_on "libusb"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "doc/cyme.1"
    bash_completion.install "doc/cyme.bash" => "cyme"
    zsh_completion.install "doc/_cyme"
    fish_completion.install "doc/cyme.fish"
  end

  test do
    # Test fails on headless CI
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = JSON.parse(shell_output("#{bin}/cyme --tree --json"))
    assert_predicate output["buses"], :present?
  end
end
