class DailyVerse < Formula
  desc "CLI tool for displaying Bible verses in the terminal"
  homepage "https://github.com/patlehmann1/daily-verse"
  url "https://github.com/patlehmann1/daily-verse/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "27b057c927fc53b6e2679b09a996e1e75a145926886e9642c39497aa6398195c"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # Test version output
    output = shell_output(bin/"daily-verse --version")
    assert_match "daily-verse v1.0.0", output

    assert_match /\w+/, shell_output(bin/"daily-verse --daily")
  end
end
