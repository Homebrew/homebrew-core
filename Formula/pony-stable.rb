class PonyStable < Formula
  desc "Dependency manager for the Pony language"
  homepage "https://github.com/ponylang/pony-stable"
  url "https://github.com/ponylang/pony-stable/archive/0.1.1.tar.gz"
  sha256 "59be7487dd979e5da6a361ed06f98606d4efb2e5ddccdcf0514a082261873d8d"

  bottle do
    cellar :any_skip_relocation
    sha256 "0afa43b5e2bfa6b72101e6309d67534fb303b9f0a208bdab1b9d837900af7332" => :high_sierra
    sha256 "78433895ad4649cfda676d3d3b877129e82c8d2098d8b55e7ce13e2d2c7fb7ee" => :sierra
    sha256 "e57060bb434d62c78583774510f081bdef1b0d8c3be357ce88db5b64744b8d29" => :el_capitan
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
