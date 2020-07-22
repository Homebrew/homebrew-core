class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/v0.4.0.tar.gz"
  sha256 "8aa13bfabfd648d42aa35b77eada5fe7ed6cca11a5b1d39a6e73050bb9d271b7"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "748634b4dee5550ad9cfbcfc2d0f31fca67126bac60e6d0be32ad40a891525d2" => :catalina
    sha256 "e22630186be4a6409259c46904779dac011f32d96d48b1d610057dbdfe049420" => :mojave
    sha256 "f67098ac6246795347f7fe3014bd12249d21a0e9279df4671a1743866be819bb" => :high_sierra
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
