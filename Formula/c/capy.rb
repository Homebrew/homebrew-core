class Capy < Formula
  desc "Copilot to build antifragile system"
  homepage "https://tryantifragile.ai/"
  url "https://github.com/AntiFragile-AI/copilot/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "2e218b3d45b6a7bb2e5cdea7fa6d629ec9b3cf813f71d18aa04df79d629090c3"
  license :public_domain

  depends_on "python@3.11" => :build

  def install
    bin.install "capy_script.sh" => "capy"
    libexec.install Dir["*"]
  end

  test do
    assert_equal true, File.exist?("#{bin}/capy")
  end
end
