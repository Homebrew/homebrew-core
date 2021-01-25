class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/v0.4.4.tar.gz"
  sha256 "e40fa987e0a2ab8f04b00ea90892b0ccdcecbb2e8d2cafc2ca318aa44a7dcf03"
  license "MIT"
  head "https://github.com/hatoo/oha.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "948fb9ba126aab229a17dd9c273f01eb62488abf0282f1cbc8e22d4402a6ec2c" => :big_sur
    sha256 "b6fc6998a4ee6c6042fe89fa971b82ed8cd953f87646efc063d3ae149ceab2b2" => :arm64_big_sur
    sha256 "3c542d6da4bcaf5acf993f6e775019ca5c9299a8a772c67386f4b988731cbee1" => :catalina
    sha256 "5ad840b9b8d11da27f29a54c7587d4baeb6bffbd36ce86cd17327c8d2b5dfa28" => :mojave
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = "[200] 200 responses"
    assert_match output.to_s, shell_output("#{bin}/oha --no-tui https://www.google.com")
  end
end
