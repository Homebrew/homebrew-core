class Hwatch < Formula
  desc "Modern alternative to the watch command"
  homepage "https://github.com/blacknon/hwatch"
  url "https://github.com/blacknon/hwatch/archive/refs/tags/0.3.7.tar.gz"
  sha256 "a7c7a7e5e2bddf9b59bd57966eaf65975bb3a247545c2be2374054f31aa0bcb8"
  license "MIT"
  head "https://github.com/blacknon/hwatch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f81137d5f459ff77cab5153089ceaef8b92c56e8ef4005806f2a3f057116aea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1da8c036c53f6953a6092edac0a7292e91b318ff1e85ddf89d425f2a63d1f9cd"
    sha256 cellar: :any_skip_relocation, monterey:       "a0619560c81e97e7c738553bff3d2afa46b6da4b364561ed3aa6db44647ba594"
    sha256 cellar: :any_skip_relocation, big_sur:        "16ca4b32162ac2d45cee5e838036ba8a9245fcadc3db34bcda3445de6d0c0ebc"
    sha256 cellar: :any_skip_relocation, catalina:       "4ac761cccaaea7be4ae3cd779bae955ed8f7cd65652e8a0c7bc0f1fc59030cea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8a88f94e413cb3a171a0f9d408c1395f75ca0810f1ca8953cfd68e0e4897f22"
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
    ensure
      Process.kill("TERM", pid)
    end

    assert_match "hwatch #{version}", shell_output("#{bin}/hwatch --version")
  end
end
