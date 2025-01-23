class Hwatch < Formula
  desc "Modern alternative to the watch command"
  homepage "https://github.com/blacknon/hwatch"
  url "https://github.com/blacknon/hwatch/archive/refs/tags/0.3.18.tar.gz"
  sha256 "db1681c634a39dd6c930441d8bdaa7d875ffc87e9cf7753c6f4bb0a46ff062b0"
  license "MIT"
  head "https://github.com/blacknon/hwatch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6735cc9fea82d18eda753c79be329b92ae1800a2621ed4f0e199f3ba3bc6c16b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "034c55531a62799f62742d6681a9dc90091f6c7863c2fe397e4bfcc439a7af01"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b505c15ed112d652ebf8afaee555a8d8eaf202a47378c6fe2e2919dae63a069"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a78584858dc498243a0b0871a5410988d82a826d55d725492c6ddb2eaf54efc"
    sha256 cellar: :any_skip_relocation, ventura:       "1f26daf105816dd62b7f79c48ec53cbe5081908786de3490a6170afb784a875a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e263ce73c650ee1a4ed37c49de9eced429a289c7faf770ee5795346ef83d4fc8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/hwatch.1"
    bash_completion.install "completion/bash/hwatch-completion.bash" => "hwatch"
    zsh_completion.install "completion/zsh/_hwatch"
    fish_completion.install "completion/fish/hwatch.fish"
  end

  test do
    begin
      pid = fork do
        system bin/"hwatch", "--interval", "1", "date"
      end
      sleep 2
    ensure
      Process.kill("TERM", pid)
    end

    assert_match "hwatch #{version}", shell_output("#{bin}/hwatch --version")
  end
end
