class AiMate < Formula
  desc "ai voice ui toolkit at your terminal"
  homepage "https://www.github.com/DavidValin/ai-mate"
  url "https://github.com/DavidValin/ai-mate/releases/download/0.3.3/ai-mate-0.3.3-macos-arm64.tar.gz"
  sha256 "02af56ba75547454053cf5d1c1ebd8017e1e2154298107f14f01cf79546d7077"
  license "Apache-2.0"

  depends_on macos: ">= :big_sur"

  on_macos do
    depends_on arch: :arm64
  end

  def install
    bin.install "ai-mate"
  end

  test do
    system "#{bin}/ai-mate", "--version"
  end
end