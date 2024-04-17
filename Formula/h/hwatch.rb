class Hwatch < Formula
  desc "Modern alternative to the watch command"
  homepage "https://github.com/blacknon/hwatch"
  url "https://github.com/blacknon/hwatch/archive/refs/tags/0.3.12.tar.gz"
  sha256 "f8db316a3b186f0dbf863ce285c8d5642f709a8527022fd2c18162f26c5b6f3d"
  license "MIT"
  head "https://github.com/blacknon/hwatch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf501395309581c677aa7ed06162e714accf1bfd1f478b1e174931dc5978ca31"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ec3395e182bece9d69f34d92254fced4231d832fb33c5de63a18ec039ed89ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f008eae455424510a7596c992ea87e543bca2380cfba859aa913979f9435ffd8"
    sha256 cellar: :any_skip_relocation, sonoma:         "e9113d4000e52085bd275790383f8ebe5b2d767b39341791e4e70fbfa648dc26"
    sha256 cellar: :any_skip_relocation, ventura:        "38c310b6492893eed18cd5777c540e78f2024de5a96de27e42a43c30a9b00bba"
    sha256 cellar: :any_skip_relocation, monterey:       "777933083571966d30e77cf506681f420fadaa72e8e0ee50a0fdc4ceeaf78f2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2e81b11493bdb014a95cfb2c3d52b8091ec318923ef7f3ae80295bd85cdf9c6"
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
