class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://github.com/bensadeh/circumflex/archive/refs/tags/2.5.tar.gz"
  sha256 "598bf2b5c1bf77aa5a7dd86c8f5995955f9170eaa035af5b0a0d236f46217bd6"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e6878dd75df402c4107ee51b8aa15a12a18b137c17202c4afef386954551182"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb283127f2664cb5e623fcc252a4a1f5cd145c0c2f4d86872baba01bbb0a1467"
    sha256 cellar: :any_skip_relocation, monterey:       "340cee291aedbd569d178e3a1bfe65c5a53d1183e810a00e7ab21bdab54e80dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "a6d97c019a6f0c8945159657d9cf863bf8442a336e9f0e714d690b077dca99f9"
    sha256 cellar: :any_skip_relocation, catalina:       "3bee38df9421a64ae9a473906c8710f85f32af9655e44309a32a9e1d84575b7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d081aebb8e4a25539de37f13da06496689fe02958ce634b8f4b14429e7a72a31"
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
