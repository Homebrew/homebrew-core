class Oscleaner < Formula
  desc "Cross-platform system cleanup CLI"
  homepage "https://github.com/hebertcisco/oscleaner"
  url "https://github.com/hebertcisco/oscleaner/releases/download/v1.0.0/oscleaner-v1.0.0-source.tar.gz"
  sha256 "92de3efb66c4f3ac9c868dcabf86de10dc0723ffccb7c736e24c749d59bc722d"
  license "MIT"
  head "https://github.com/hebertcisco/oscleaner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "75c54d29c5b190522808efdb6ab16845d682719a131a80a01bad4235b26973da"
    sha256 cellar: :any_skip_relocation, sequoia: "5004c78f005d011642a51bc70aa3e6fa5c91b882bd15bb7fa6f6b2e9957443ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "90cf393ba52d8cfab480c24ae5346f98e46363ce109c064e3724ebd9b6ff56b1"
  end

  on_macos do
    depends_on "rust" => :build
  end

  on_linux do
    url "https://github.com/hebertcisco/oscleaner/releases/download/v1.0.0/oscleaner-v1.0.0-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "ce48ec64e9817b0c0d1ca3d641d671a2357285b91e6f46ef81161379d9d0dbdd"
  end

  def install
    if OS.mac?
      system "cargo", "install", *std_cargo_args(path: ".")
    else
      bin.install "oscleaner-v#{version}-x86_64-unknown-linux-gnu" => "oscleaner"
    end
  end

  test do
    output = shell_output("#{bin}/oscleaner --help")
    assert_match "oscleaner", output
  end
end