class PonyStable < Formula
  desc "Dependency manager for the Pony language"
  homepage "https://github.com/ponylang/pony-stable"
  url "https://github.com/ponylang/pony-stable/archive/0.1.3.tar.gz"
  sha256 "75b40a965469865aa3bf9b2f791fc641cb92854ba718d3bd66c68764cd20b16c"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f35e860efd3dca0af2f38d3555ffd19af88cfe0ead20d81c3e01df670fd0226" => :high_sierra
    sha256 "cbd5de6c654b2a4d475ce0a7feeda80e778315c8716bc2270134d00311e28d08" => :sierra
    sha256 "c764f8032baf9a9f2eb173901ad365fcd99b3c4280f07f0d9396a48e770b21a3" => :el_capitan
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
    system "#{bin}/stable", "env", "ponyc", "test"
    assert_equal "Hello World!", shell_output("./test1").chomp
  end
end
