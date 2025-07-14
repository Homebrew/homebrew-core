class Cyme < Formula
  desc "List system USB buses and devices"
  homepage "https://github.com/tuna-f1sh/cyme"
  url "https://github.com/tuna-f1sh/cyme/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "566f9d7ee9dd183ddcc9f5a51a08446e84ba73222149298f5f64c606032355b2"
  license "GPL-3.0-or-later"
  head "https://github.com/tuna-f1sh/cyme.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b472bfe15fa11e86fa90007edb1933a6784853bfe26cfa031b1b9e89f0852880"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e8f4a0c9e0d63b5069d1a81e9931e94a246bbdcaee7b83c22ab72f437b81a48"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3cbaf1c83b1c8b03bee209fd1e5ad7142d5a6ab598044b61454b31eae8210c5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "37cb2c4f6b58949c44ef92c9f49181766ad1a51b0232a339add92601e6016dad"
    sha256 cellar: :any_skip_relocation, ventura:       "4ed3632feb1c633f7a6bdd68ff79c2edbc1fdeccc5fa89ec63d691dd1be2aa28"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7ba7d8fdcf67e0c8ad7f29d9b633d3bf734712a944646b2d06f17e47d3664ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "324cd0f6ed32816d04551b36e945324a4f3ae3791dcd0f0afa6213c0854e8765"
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
