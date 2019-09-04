class Outliner < Formula
  desc "CLI tool for Auto setup and deploy outline VPN"
  homepage "https://github.com/Jyny/outliner"
  url "https://github.com/Jyny/outliner/archive/v0.1.4.tar.gz"
  sha256 "70ba981d16d82ce3058152b9666760efb9c3fb38cef515e9c11dda496c98ef7b"
  head "https://github.com/Jyny/outliner.git"

  depends_on "go" => :build

  def install
    system "make"
    bin.install "outliner"
  end

  test do
    assert_match "outliner", shell_output("#{bin}/outliner")
  end
end
