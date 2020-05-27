class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/v0.3.1.tar.gz"
  sha256 "54edf861415d12e5482c09296d2715aad0a828ff8a5c6241fa80e6d08fd058c1"

  bottle do
    cellar :any_skip_relocation
    sha256 "748634b4dee5550ad9cfbcfc2d0f31fca67126bac60e6d0be32ad40a891525d2" => :catalina
    sha256 "e22630186be4a6409259c46904779dac011f32d96d48b1d610057dbdfe049420" => :mojave
    sha256 "f67098ac6246795347f7fe3014bd12249d21a0e9279df4671a1743866be819bb" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    output = "[200] 200 responses"
    assert_match output.to_s, shell_output("#{bin}/oha --no-tui https://www.google.com")
  end
end
