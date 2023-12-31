class Hwatch < Formula
  desc "Modern alternative to the watch command"
  homepage "https://github.com/blacknon/hwatch"
  url "https://github.com/blacknon/hwatch/archive/refs/tags/0.3.10.tar.gz"
  sha256 "e2427fc634eb4ab4cd28d9629ee06896494b70a009eaacff302f849939291670"
  license "MIT"
  head "https://github.com/blacknon/hwatch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5f032b24bbc206eb795951e8c382169e50851a29e12f39791791fe658a61b3c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25de061a2a13f19f9d69e529dfadb0c77a5533a0c6fc8ad6c6d46e61316757fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec7ab2fe9568429d392c376b3603ade438d20a55132f412d3908584777a1c862"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1902338d1964921d2a8667c7569c182d2b8dd14210d666a202745b4dc3fb7697"
    sha256 cellar: :any_skip_relocation, sonoma:         "936494af0f47f2ba3769cadee4e8a76aca0abc647f06600d24ec2cb8196fb1e5"
    sha256 cellar: :any_skip_relocation, ventura:        "181d01ea92759dfdcdf6f521f8b5f8b418647308b94bed43a25c0af726019b35"
    sha256 cellar: :any_skip_relocation, monterey:       "c5a993d24fb4e9a600fe0c149832a55151ddd844a1cb028d1dbf80bc98755bb6"
    sha256 cellar: :any_skip_relocation, big_sur:        "deeb93f5e622d000d3cf883fe647da7c71926621bbe14c0b6b31edc38c51c3c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42718f0c1bc6621b7210f1bff7adb9f53e9b403a1b53d6f85c85696d97a0b400"
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
