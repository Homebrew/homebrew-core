class Cyme < Formula
  desc "List system USB buses and devices"
  homepage "https://github.com/tuna-f1sh/cyme"
  url "https://github.com/tuna-f1sh/cyme/archive/refs/tags/v2.2.4.tar.gz"
  sha256 "c8e6f5c3a3055ed221b21521e7c5bdc544550e1f1d3c8167f8d471b5a931cd41"
  license "GPL-3.0-or-later"
  head "https://github.com/tuna-f1sh/cyme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8144b960eaa8a5a805054b6fc8b4a61e49d85eced48bcc8b29248f38fc8a5a14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdeb2650e261eb4626e7ff624c6338658d545fefcf0ad49b5b1e7a5341bfeb65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b816a856b11bb20c03aa06ba36736a2edc22690d92864f99f00cd330876cccf5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e772b305715431c1578d8ff7e17143ebf57f3eb04060360eaf46cfe5e26e311"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4a7c10bcc7ddcba72c97b6c01a5905432c86b7ae4197ec4c34abf2797bc4baf"
    sha256 cellar: :any_skip_relocation, ventura:       "3ebde37e92e3049dbde111cc1719e2ecd439d5d308e82670d04b3cfb47900839"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb5553a029e923b800a56c32803befa9f90864c714792506d0ad7b9308ba18a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e10cdb7bbb06b9613bc3718d15dccada0e0e8c888a30555f1e31e6004a239e6f"
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
