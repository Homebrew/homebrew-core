class Proxify < Formula
  desc "Portable proxy for capturing, manipulating, and replaying HTTP/HTTPS traffic"
  homepage "https://github.com/projectdiscovery/proxify"
  url "https://github.com/projectdiscovery/proxify/archive/refs/tags/v0.0.12.tar.gz"
  sha256 "ed58d5e2cf5d25f7f067e5b9d9b6c5de82d6d989dd04c7be40b4aef0beddb1ed"
  license "MIT"
  head "https://github.com/projectdiscovery/proxify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "553399eb553d799ecb88926b2d1456f142eb249f0954b24b1b3e7c9829599247"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "553399eb553d799ecb88926b2d1456f142eb249f0954b24b1b3e7c9829599247"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "553399eb553d799ecb88926b2d1456f142eb249f0954b24b1b3e7c9829599247"
    sha256 cellar: :any_skip_relocation, ventura:        "0ac4ac1f0d17c20fa320ee3f8d55458491d70a08b93b891ee0a8b993913bbe36"
    sha256 cellar: :any_skip_relocation, monterey:       "0ac4ac1f0d17c20fa320ee3f8d55458491d70a08b93b891ee0a8b993913bbe36"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ac4ac1f0d17c20fa320ee3f8d55458491d70a08b93b891ee0a8b993913bbe36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "230a63dced3306bff64b691cf350a15b6c59b868de9340450683679eeedcc129"
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
