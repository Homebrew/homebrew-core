class PonyStable < Formula
  desc "Dependency manager for the Pony language"
  homepage "https://github.com/ponylang/pony-stable"
  url "https://github.com/ponylang/pony-stable/archive/0.1.6.tar.gz"
  sha256 "1e980924ff7ea03e07f2eb16e5ae826ff9142f659aa83127ca80c1055af59748"
  head "https://github.com/ponylang/pony-stable.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "91185d0a73628759d5e3462ab943d5af75d0d93924f342d3a1dc482218375eca" => :mojave
    sha256 "571fd986d8e2bd5fc89e382b14d8753c8ce1c3192c9965685564ee5cdb31e697" => :high_sierra
    sha256 "5d0b08013d2cf38ffbd4e0fe521caf03281e897b3c64e565fd169c885bf56c22" => :sierra
    sha256 "2396f10782e12343c245196d0265df84e106cd2a26496f1e7f1c90f9b55a99b3" => :el_capitan
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
