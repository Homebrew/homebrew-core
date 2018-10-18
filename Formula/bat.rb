class Bat < Formula
  desc "Clone of cat(1) with syntax highlighting and Git integration"
  homepage "https://github.com/sharkdp/bat"
  url "https://github.com/sharkdp/bat/archive/v0.8.0.tar.gz"
  sha256 "577664399cf24695f51b702350c1a3fe460cd296a6a12ed0938bb937a4b3b00d"

  bottle do
    sha256 "51ad433dcb1a2eda8f31f300588ab6371933bf07cb4ba5fc156e0846ae101999" => :mojave
    sha256 "fd731a798b6d3a11032afa64bb7f5361c05af3ce555e49276528ee7afdd57882" => :high_sierra
    sha256 "47e906eda55ebb73bf5b3f1173cf0caa27d9fa183c8a6af24ceb42268984f789" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
    man1.install "doc/bat.1"
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/bat #{pdf} --color=never")
    assert_match "Homebrew test", output
  end
end
