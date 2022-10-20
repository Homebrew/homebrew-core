class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://github.com/bensadeh/circumflex/archive/refs/tags/2.6.tar.gz"
  sha256 "f30e346aa4cd31b46bbba69cdd17d3bf879607bc5d67c3c2940f511458d19645"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64bd4f4342b066f7cca2453bfe7398afdbf76f6aed914eafbe5687948895148a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "087c54911807713f432e0ef3a60d9e68b56674412fc584ea0f2771eb39e4269c"
    sha256 cellar: :any_skip_relocation, monterey:       "c5ae56d6a4efbc52815058f9faa75d05903c5aab0f4491da28c08077dc73c97c"
    sha256 cellar: :any_skip_relocation, big_sur:        "992a35b0c066c88eef1a87267701943b3083d7359f6813dc794df5c71d79428b"
    sha256 cellar: :any_skip_relocation, catalina:       "4c249801432886e0407488ad7c2da3cc6bebf943a80661093a4f76dde079b26e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fda71cd57fc6ef3cacb9ef7a34a819940a21244c30d8a39f423cccd69dc00c0"
  end

  depends_on "go" => :build

  # Requires less 576 or later for --use-color
  uses_from_macos "less", since: :monterey

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
