class Ponyc < Formula
  desc "Object-oriented, actor-model, capabilities-secure programming language"
  homepage "http://www.ponylang.org"
  url "https://github.com/ponylang/ponyc.git",
    :revision => "aafebac938273d4786c02dfb2ba9ec7a164675e7"
  version "0.2.2-candidate"

  bottle do
    cellar :any_skip_relocation
    sha256 "767013d4ffb5ae596f17282b80205034601f029b649b8b5e428fde32ca5e27f0" => :el_capitan
    sha256 "08857152c0ba5a5dc00b96a7e3d1c47a8ef4710dca6262e3eae0dd90122b29f3" => :yosemite
    sha256 "007c43a75741ecd4c7c96c9fc67d816ebc845c0aac94687c4e2cbb1ee959ebfb" => :mavericks
  end

  depends_on "llvm"
  depends_on "libressl"
  depends_on "pcre2"
  needs :cxx11

  def install
    ENV.cxx11
    ENV["LLVM_CONFIG"]="#{Formula["llvm"].bin}/llvm-config"
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
