class Cyme < Formula
  desc "List system USB buses and devices"
  homepage "https://github.com/tuna-f1sh/cyme"
  url "https://github.com/tuna-f1sh/cyme/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "a4259f3a77a9b01dc1e8968a184113d47e353c332520f9384cd8d90f5d88b7bb"
  license "GPL-3.0-or-later"
  head "https://github.com/tuna-f1sh/cyme.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "244a202824cc27d020db9505baf4ee03eec551e0799b6d9d35e4c2c2e14276ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92f56bf275c07bf90c444333cc92dcc46a7db09c012c9cab7ed1e97b2fbebd5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e017e04dce4daf71bf0005c1ee4cb16ee2a51ead69b65d98df12230fce055a6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b20b8975c9dd97bf1bdd643bce57e60df1dd06243c69046456c02e7c1261e4ec"
    sha256 cellar: :any_skip_relocation, ventura:       "0606d756ecb564d38ec451de8e5d5e3b3f5608a344efb1008653f37b81f4f386"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c626a54bf672a2aebf0d339aff3a5c42c6e07029fecb340b6832653a5026225a"
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
