class PonyStable < Formula
  desc "Dependency manager for the Pony language"
  homepage "https://github.com/ponylang/pony-stable"
  url "https://github.com/ponylang/pony-stable/archive/0.1.6.tar.gz"
  sha256 "1e980924ff7ea03e07f2eb16e5ae826ff9142f659aa83127ca80c1055af59748"

  bottle do
    cellar :any_skip_relocation
    sha256 "10436ef965fc48695cd616fba08553c6c148c2342ffc84b544065235b8598f24" => :high_sierra
    sha256 "81a1d524559da660cc210f1bf291de9416000174e8a3bdb123879c54287c50a1" => :sierra
    sha256 "6358aced5d98bebec8aac6c26bbf44ff0001a8a0997feb30bd7a159d6b91b939" => :el_capitan
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
