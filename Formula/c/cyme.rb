class Cyme < Formula
  desc "List system USB buses and devices"
  homepage "https://github.com/tuna-f1sh/cyme"
  url "https://github.com/tuna-f1sh/cyme/archive/refs/tags/v2.2.8.tar.gz"
  sha256 "a4fc0d5e2434d9a98f1b37683d3c1fe60d8605e8ad99f0a4f95387830c81b930"
  license "GPL-3.0-or-later"
  head "https://github.com/tuna-f1sh/cyme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca3eaa3054e0ee730cf3225c50b9d526d6e1137346a1218ad6e8419ed2efd68f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "268b0fcc83a178de1481c56f2aa11fa5d9157dcdc32707b148f17117629519fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd3c534fba3b91457f8b005eaab8f92662f14869f553690ce8431b8ec8fe37d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e80c8df9df289d479ea3984a7b4a3c80b21dd4aaa4b8a02cdfa679ac3a701bbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbd99ea1feb4c065d13ca4f30bc9422b0652d2d028e63df4bb1a10b8638fc1e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee7316242d6f427fcf9f4558308ac946a0eb78c9a7df2282ed5055e3ef4f4e2f"
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
