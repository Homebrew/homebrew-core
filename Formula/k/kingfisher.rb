class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://github.com/mongodb/kingfisher"
  url "https://github.com/mongodb/kingfisher/archive/refs/tags/v1.68.0.tar.gz"
  sha256 "9c1c3d17d6313eac99c0402a01ac4cdd23f22a743d3c53cea8fbff682905a3cd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7633216dffaa4f3cdd7be40e472d3d856ac992f7c2afde3c14b4d48acbc0465c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "668465e7e71c836852ba679e52714318a66476e3d27896f68bdeca29ebce061a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e325c44ffee8dfeed3f91b1aef4fa921c7cf120dd2fba1e37152210840a6e6fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "da385fb2074b3affb9996fae517c504ff40fa95e0c4c3b2af16f2ca59b7d9e6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dddcf3d42ce5b9573e1b41cfe26c93e053de3b0acd9683fba97fc53bcc6c1f65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0e37a997f2e83958e818c215fdca72ffcb8017d6683e77914f5eef0c1da142e"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    system "cargo", "install", "--features", "system-alloc", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end
