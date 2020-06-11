class Corral < Formula
  desc "Dependency manager for the Pony language"
  homepage "https://github.com/ponylang/corral"
  url "https://github.com/ponylang/corral/archive/0.3.6.tar.gz"
  sha256 "9f5b4e500374142098bf30274d69375507b6c3e44f653d518b61cdddae646a83"
  head "https://github.com/ponylang/corral.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "19cfd5fbbc9c8af9ebccd9042fe727acca4cd7dfd9af23cc2101c905085f5168" => :catalina
    sha256 "c000242469b19b4d27cabb97a463491a53b47c5b864629f490da6b4a770121dc" => :mojave
    sha256 "32d3f76157e135760daf96354f733e3a2e436b3120265db3c635f6da7a8fd3c1" => :high_sierra
  end

  depends_on "ponyc"

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/"test/main.pony").write <<~EOS
      actor Main
        new create(env: Env) =>
          env.out.print("Hello World!")
    EOS
    system "#{bin}/corral", "run", "--", "ponyc", "test"
    assert_equal "Hello World!", shell_output("./test1").chomp
  end
end
