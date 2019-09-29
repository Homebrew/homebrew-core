class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.6.6.tar.gz"
  sha256 "bf97b166b1f0c55e27c85943f3335ccec00219123b364863c0132f7d29d39e29"

  bottle do
    cellar :any_skip_relocation
    sha256 "afa66db3c4554dbc23b998785e8b2c512707b3cfc5aa6170a58ef6b2a7514785" => :mojave
    sha256 "d5623048eaa23bd332ba7c48680ec2f739a95630483791fd3b54a782b9699e36" => :high_sierra
    sha256 "423e6122f04716a20225cd6efb802adc2f6b79dda157746c3366d59a3a99e7cd" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    touch testpath/"test.txt"
    cmd = "#{bin}/fselect name from . where name = '*.txt'"
    assert_match "test.txt", shell_output(cmd).chomp
  end
end
