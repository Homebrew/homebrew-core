class Oscleaner < Formula
  desc "Cross-platform system cleanup CLI"
  homepage "https://github.com/hebertcisco/oscleaner"
  url "https://github.com/hebertcisco/oscleaner/releases/download/v1.0.0/oscleaner-v1.0.0-source.tar.gz"
  sha256 "96a9bc280f9f2ec06e6206d9599769911173b729169bc675c5614c29d65b2607"
  license "MIT"
  head "https://github.com/hebertcisco/oscleaner.git", branch: "main"

  bottle do
    root_url "https://github.com/hebertcisco/oscleaner/releases/download/v1.0.0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "993b70e8ff55fadcea9e213574976b68ebd1b7fc9431af5abae6a72fb9e7cbbf"
    sha256 cellar: :any_skip_relocation, sequoia: "142a8600351189d0844c4d88ec4f942135e2436d1066a572c6ba47141a95198e"
  end

  on_macos do
    depends_on "rust" => :build
  end

  on_linux do
    url "https://github.com/hebertcisco/oscleaner/releases/download/v1.0.0/oscleaner-v1.0.0-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "6d3776e5d3bed67efb29fce47548fa5faf9eb9f653e301cbbe2f1f40c1ad429c"
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