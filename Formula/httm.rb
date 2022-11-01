class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.16.7.tar.gz"
  sha256 "813fe0988d4e1ba391d356e05abfe202eee99495e64cd928fbfc0e15a2093301"
  license "MPL-2.0"

  head "https://github.com/kimono-koans/httm.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "httm.1"
  end

  test do
    system "#{bin}/httm", "--version"
  end
end
