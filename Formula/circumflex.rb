class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://github.com/bensadeh/circumflex/archive/refs/tags/2.8.tar.gz"
  sha256 "b3ac1ab35ce4716290ad40898b3227b4b18197f8068a8f03fb1069231e60104e"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b783c1b14ecc5db8e6da36137b37c547200e8eff8924f52fdb0cd3d99d1a1ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51177211c28b0b7500e526339ab3d576a0aff56b7b7bbbe6b91267ee1ccae6be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d70f5cb026e3b1837dce773c64682ed3ca12211b8ccbfa693005f666775e180"
    sha256 cellar: :any_skip_relocation, monterey:       "be4374762a967ee7f98915ceaa30deb6f5417c8970d97a64a7e3ecc3aa44918e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c91405e80fef9b5d4521cd34abb93fd77996642a524526e67c3b382801817cca"
    sha256 cellar: :any_skip_relocation, catalina:       "11ac81f3f5c237130e7e2aa4aca09d9ab3f6af07a8c439805c71b62dd32df8e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d9cee4859267389c616eb42727abcb9f57a3a7105bb0fecf5c94323665a48a7"
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
