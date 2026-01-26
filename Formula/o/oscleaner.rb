class Oscleaner < Formula
  desc "Cross-platform system cleanup CLI"
  homepage "https://github.com/hebertcisco/oscleaner"
  url "https://github.com/hebertcisco/oscleaner/releases/download/v1.0.0/oscleaner-v1.0.0-source.tar.gz"
  sha256 "92de3efb66c4f3ac9c868dcabf86de10dc0723ffccb7c736e24c749d59bc722d"
  license "MIT"
  head "https://github.com/hebertcisco/oscleaner.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    output = shell_output("#{bin}/oscleaner --help")
    assert_match "oscleaner", output
  end
end
