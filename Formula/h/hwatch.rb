class Hwatch < Formula
  desc "Modern alternative to the watch command"
  homepage "https://github.com/blacknon/hwatch"
  url "https://github.com/blacknon/hwatch/archive/refs/tags/0.3.13.tar.gz"
  sha256 "a9fb477ce8682919fe2af89a4f8c9286c525fa384161aa2cf1e0fad2c57b1877"
  license "MIT"
  head "https://github.com/blacknon/hwatch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a487ce037a517ce27cfdb66989385c3e6b683ba1a7894af945eeb4a0ee29fa27"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e0aa825a8792ae6d6605b728875914cc1c8df4780e099e06d70af6e0eca1fbd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0aef00561e2b7568770fd7916cd9ced544d5b316fb10d069e5ec56f0aa5ebd05"
    sha256 cellar: :any_skip_relocation, sonoma:         "52a84a0ca33c34844aad5b0a1a2d81a69cd3949fff95888cf30f74bf8fe3a51c"
    sha256 cellar: :any_skip_relocation, ventura:        "fa3f82557e2668882c0395d39135316eee8295a6cbff7f626cf0b606f2dcf116"
    sha256 cellar: :any_skip_relocation, monterey:       "72e8df1238474abedde217289bd454ad1c2d6e643543fc73a202dece3a23e377"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "893ea5a3680db6231b700d793196ed2e63158a40617ef89cbb5e153f911e4b77"
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
