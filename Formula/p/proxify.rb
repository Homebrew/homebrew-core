class Proxify < Formula
  desc "Portable proxy for capturing, manipulating, and replaying HTTP/HTTPS traffic"
  homepage "https://github.com/projectdiscovery/proxify"
  url "https://github.com/projectdiscovery/proxify/archive/refs/tags/v0.0.15.tar.gz"
  sha256 "21e7d9cfa047d66353e98daeaff9d182091168e2385746dbbd0c194de792fbb5"
  license "MIT"
  head "https://github.com/projectdiscovery/proxify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "39ea56f39dbaea441033365e4358b6309f4a1edc57c8c4e1da3589116e9bb1f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94e7a827c246a32d96900d31f14e0e61e4d8c6dc9dc67b8cadd58dca4d3a7afb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aeccbf06a4f155d04bc47c80e9b8153e245b72c1733055a915c349bfa32aa9c2"
    sha256 cellar: :any_skip_relocation, sonoma:         "45b43ce529defc187fc3c320de3f33b145cdb70a634ffbe941d4ab45826cc3ba"
    sha256 cellar: :any_skip_relocation, ventura:        "977972b579f4aa7e10c4dbe1531f9276c58a1687555c7d941b8418a4c73d1d5d"
    sha256 cellar: :any_skip_relocation, monterey:       "dc5b8b674c939e3684d406acab6df3c512bb7894504c5abec335f92690b0ca72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ed88a3f831f79098c29ada2a158a38f5d1f37d2aa8bd5daa25a3ad7ad3698b9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/proxify"
  end

  test do
    # Other commands start proxify, which causes Homebrew CI to time out
    assert_match version.to_s, shell_output("#{bin}/proxify -version 2>&1")
    assert_match "given config file 'brew' does not exist", shell_output("#{bin}/proxify -config brew 2>&1", 1)
  end
end
