class Getquotes < Formula
  desc "Terminal tool for fetching quotes from WikiQuotes"
  homepage "https://github.com/MuntasirSZN/getquotes"
  version "0.3.5"
  license "MIT"
  
  url "https://github.com/MuntasirSZN/getquotes/archive/refs/tags/v#{version}.tar.gz"
  # You'll need to update this SHA256 with the actual source archive hash
  sha256 "2a723b0d449613d7d85404872b8ec2fac43dbc858df8670445e698c70855a343"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/getquotes.1"
  end

  test do
    assert_match "getquotes v", shell_output("#{bin}/getquotes --version")
    assert_match "Usage: getquotes", shell_output("#{bin}/getquotes --help")
    assert_path_exists man1/"getquotes.1"
    system bin/"getquotes"
  end
end
