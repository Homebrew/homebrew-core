class Getquotes < Formula
  desc "Terminal tool for fetching quotes from WikiQuotes"
  homepage "https://github.com/MuntasirSZN/getquotes"

  url "https://github.com/MuntasirSZN/getquotes.git",
      tag: "v#{version}"

  license "MIT"

  depends_on "git" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/getquotes.1"
  end

  test do
    assert_match "getquotes v", shell_output("#{bin}/getquotes --version")
    assert_match "Usage: getquotes", shell_output("#{bin}/getquotes --help")
    assert_path_exists prefix/"share/man/man1/getquotes.1"
    system bin/"getquotes"
  end
end
