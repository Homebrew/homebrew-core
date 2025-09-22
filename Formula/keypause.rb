class Keypause < Formula
  desc "Pause/unpause keys on macOS (CLI tool)"
  homepage "https://github.com/elijahfriedman/keypause"
  url "https://github.com/elijahfriedman/keypause/releases/download/v1.0.0/keypauseapp"
  sha256 "62549f54d66001a759a6bdce0a991449b39ba4ef0eac3cb913f5a51c3fed79a2"
  license "MIT"

  def install
    bin.install "keypauseapp" => "keypause"
  end

  test do
    assert_match "Keypause", shell_output("#{bin}/keypause --help")
  desc "Lock and unlock the keyboard and the cursor"
  homepage "https://github.com/elijahfriedman/keypause"
  url "https://github.com/elijahfriedman/keypause/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "6ebdba2968173ec96ce3dd2e4405e0ea29ed5b719a9d38ede1a1896be6b5a68e"
  license "MIT"

  depends_on xcode: ["14.0", :build]

  def install
    cd "keypause/keypause" do
      system "swiftc", "main.swift", "-o", "keypause", "-framework", "Quartz"
      bin.install "keypause"
    end
  end

  test do
    # Make sure the binary was installed
    assert_path_exists bin/"keypause"

    # Run it with --help to confirm it responds without hanging
    output = shell_output("#{bin}/keypause --help", 1)
    assert_match "Keypause", output
>>>>>>> 831e8054298 (keypause 1.0.0 (new formula))
  end
end
