class Outliner < Formula
  desc "CLI tool for Auto setup and deploy outline VPN"
  homepage "https://github.com/Jyny/outliner"
  head "https://github.com/Jyny/outliner.git"

  depends_on "go" => :build

  def install
    system "make"
    system "mv build/outliner_$(go env GOOS) ./outliner"
    bin.install "outliner"
  end

  test do
    assert_match "outliners", shell_output("#{bin}/outliners")
  end
end
