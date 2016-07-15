class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "http://www.ponylang.org"
  url "https://github.com/ponylang/ponyc.git",
    :revision => "5f061fa201b47dc6a767d3bbe8a8999ada66993e"
  # 0.2.2 tag requested in https://github.com/ponylang/ponyc/issues/1029
  version "0.2.2-alpha2"

  bottle do
    cellar :any
    sha256 "9d7b44d24e35e93662d1d95c001e513d8b92a44a844e35384ecb0498df08b793" => :el_capitan
    sha256 "7a4fdb983d1d7a5db646ee6f9b3290b3c7d14c8b165b86e147c5a6583ea603da" => :yosemite
    sha256 "3511e41b6c19a70c623a366e95eceb4f066226764411f03797775f16e15fbcda" => :mavericks
  end

  depends_on "llvm"
  depends_on "libressl"
  depends_on "pcre2"
  needs :cxx11

  def install
    ENV.cxx11
    ENV["LLVM_CONFIG"]="#{Formula["llvm"].opt_bin}/llvm-config"
    system "make", "config=release", "destdir=#{prefix}", "install", "verbose=1"
  end

  test do
    system "#{bin}/ponyc", "-rexpr", "#{prefix}/packages/stdlib"

    (testpath/"test/main.pony").write <<-EOS.undent
    actor Main
      new create(env: Env) =>
        env.out.print("Hello World!")
    EOS
    system "#{bin}/ponyc", "test"
    assert_equal "Hello World!", shell_output("./test1").strip
  end
end
