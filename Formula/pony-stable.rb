class PonyStable < Formula
  desc "Dependency manager for the Pony language"
  homepage "https://github.com/ponylang/pony-stable"
  url "https://github.com/ponylang/pony-stable/archive/0.0.1.tar.gz"
  sha256 "b175d5a235676eaf48b62cf28d5c44f6c13b9986d5dc97f75b477285fe9ec8fb"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ba9e20a3773db35d9ca8e8c56abe72a62714285196195d700ff5aef517de8d0" => :sierra
    sha256 "d294894e3b412a47654afafa2a573b83f57aa7cc72938914c99b416fc249355c" => :el_capitan
  end

  depends_on "ponyc"

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/"test/main.pony").write <<-EOS.undent
    actor Main
      new create(env: Env) =>
        env.out.print("Hello World!")
    EOS
    system "#{bin}/stable", "env", "ponyc", "test"
    assert_equal "Hello World!", shell_output("./test1").chomp
  end
end
