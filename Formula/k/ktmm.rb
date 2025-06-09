class Ktmm < Formula
  desc "Keep That Mouse Moving - Prevents system sleep by making periodic mouse movements"
  homepage "https://github.com/ao/ktmm"
  url "https://github.com/ao/ktmm/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "e5800176934df7539fa31b15afccc18385de794be1b4babe834dd47c659aec7e"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ktmm 0.2.0", shell_output("#{bin}/ktmm --version")
  end

  def caveats
    <<~EOS
      KTMM requires accessibility permissions on macOS.
      After installation, go to:
      System Preferences > Security & Privacy > Privacy > Accessibility
      and add KTMM to the list of allowed applications.
    EOS
  end
end