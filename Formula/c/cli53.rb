class Cli53 < Formula
  desc "Command-line tool for Amazon Route 53"
  homepage "https://github.com/barnybug/cli53"
  url "https://github.com/barnybug/cli53/archive/refs/tags/v0.8.25.tar.gz"
  sha256 "7fc01388af416b88f164244e1c7269a122b8203485313970196913982b80e56d"
  license "MIT"
  head "https://github.com/barnybug/cli53.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9095f0aee379f36b2ffdd4d9d11bdcc19806ec0bf49a2c7f9ae2b23e30d69ae4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4b9ffd175d7e981bdd4c7c2356e6268b94c6b5347a2d50d5781318a9ac53136"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4b9ffd175d7e981bdd4c7c2356e6268b94c6b5347a2d50d5781318a9ac53136"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e4b9ffd175d7e981bdd4c7c2356e6268b94c6b5347a2d50d5781318a9ac53136"
    sha256 cellar: :any_skip_relocation, sonoma:        "cdb240862a0674ac5a321b32faaac47bd536dc774b45be2c27d8d9252f3feaa2"
    sha256 cellar: :any_skip_relocation, ventura:       "cdb240862a0674ac5a321b32faaac47bd536dc774b45be2c27d8d9252f3feaa2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c9813986e728f56443c377c9117e35bcb63e306e76e8186a5b5eb7e08f817c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a78fd47c4eac438afac66284ad3aa5b4f2dd37232b5330405d1fe6657d480f76"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cli53"
  end

  test do
    assert_match "list domains", shell_output("#{bin}/cli53 help list")
  end
end
