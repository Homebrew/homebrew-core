class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://github.com/bensadeh/circumflex/archive/refs/tags/2.7.tar.gz"
  sha256 "109ff8b2a7e03b9c0dc0e6734aa6732caca88d28a9557b6865b57a53eb2e0c85"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5543152bf002dc0230e6fb0092e66063146cff512515457d73f5c52fa3979e3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e3dd80089c43e6ea8556174addca857ca3e81e1b88ecd551bdc181eba49ec1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cdbde2df35711f158e854e1e0a19c33b2e4743eea5eda179fb7e8438a84e184b"
    sha256 cellar: :any_skip_relocation, monterey:       "ef76a9f7e5d29db2b98ce3c2d8664177780c1572ddc6d1bb0e408623e48ab396"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4b68f8007ae7b440d40046e6b672aabc85b9adf50c5e372e7c07a5c2dbefb84"
    sha256 cellar: :any_skip_relocation, catalina:       "0143ffc98c1163b81e0af0d047b346d6f79184fde615a473854d26584cb6404b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb970d5eae4db814bcbb20f8d5300ea469df6fd51ab9865b662fb059a090c723"
  end

  depends_on "go" => :build
  depends_on "less"

  def install
    system "go", "build", *std_go_args(output: bin/"clx", ldflags: "-s -w")
    man1.install "share/man/clx.1"
  end

  test do
    assert_match "List of visited IDs cleared", shell_output("#{bin}/clx clear 2>&1")
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    assert_match "Y Combinator", shell_output("#{bin}/clx view 1")
  end
end
