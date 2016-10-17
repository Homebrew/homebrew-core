class Aurora < Formula
  desc "Beanstalk queue server console"
  homepage "https://xuri.me/aurora"
  url "https://github.com/Luxurioust/aurora/releases/download/1.2/aurora_darwin_amd64_v1.2.tar.gz"
  version "1.2"
  sha256 "c480e46592d6fb6f025572795bac80357f81b662cefdb3d149c77c723fb9a81f"

  def install
    bin.install "aurora"
  end

  test do
    system "aurora"
  end
end
