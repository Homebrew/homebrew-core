class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.6.7.tar.gz"
  sha256 "c044aa34255084f598d4644bb009dcce8d27e52f65584c488721ffb5b980044a"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb4d42b92ed035a6f8db32e3da543877159688651c80e4eac560b02a79cf60c4" => :catalina
    sha256 "b7fa9957ed48e2c960332278d31532d6ce459ebd911130698575506eefc4af8c" => :mojave
    sha256 "ce7be82e86c184d751b61b47ce6ff566c1f79841004606f0eff6c24250f5956b" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    touch testpath/"test.txt"
    cmd = "#{bin}/fselect name from . where name = '*.txt'"
    assert_match "test.txt", shell_output(cmd).chomp
  end
end
