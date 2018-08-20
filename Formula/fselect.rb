class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.4.4.tar.gz"
  sha256 "ab28cda96a43712e27322464010925caece4d231fa15bbd0926e284116b03a99"

  bottle do
    sha256 "327f8af8f01eda68ae637b94558af520f0dbf29582fc6b6b03d1a1dc74afda3d" => :mojave
    sha256 "88f6ac2a81d1c8844344047bbeede00103164d5b464eddf9fcd980bc55f42eed" => :high_sierra
    sha256 "28e42220ce7a4256b85076d90be380c1bec72093c4888b3ab731eb2b7dc9b426" => :sierra
    sha256 "80029282e5727b5fe532f5da101699a010b3f4759d9ebfbd473ebf84bd350e1e" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix
  end

  test do
    touch testpath/"test.txt"
    cmd = "#{bin}/fselect name from . where name = '*.txt'"
    assert_match "test.txt", shell_output(cmd).chomp
  end
end
