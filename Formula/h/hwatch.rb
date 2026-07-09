class Hwatch < Formula
  desc "Modern alternative to the watch command"
  homepage "https://github.com/blacknon/hwatch"
  url "https://github.com/blacknon/hwatch/archive/refs/tags/0.4.2.tar.gz"
  sha256 "b13a492ac1fded05ee072c904f61f227a1a5119c6767c2dbed03eb2e7c261a1f"
  license "MIT"
  head "https://github.com/blacknon/hwatch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71dff6498d09e57195888320ddb66176ff6b57f9dde0d174b8cb52998f60bfd9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4de6b83445b84c2267a981d19631fde94aaba0de0db94bc9c23e1682e5c6e02e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fcf0c8b524fcf6fc356b54237f6597a22c26de26f113c0440cb98e70e0c8255a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e225e2a5749cd5e10446d95bdde53f4f9d5ede375d00a2abb798e0521dca504e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a8e899013ab815d0ec3e578a67661f9155e73c5ca2619d1c727f3116180e525"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89005a5387b3134b32dc3125c3d98c8c43e3c144def53e8b3299b4311b1b509c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/hwatch.1"
    generate_completions_from_executable(bin/"hwatch", "--completion")
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
