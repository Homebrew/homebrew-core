class PonyStable < Formula
  desc "Dependency manager for the Pony language"
  homepage "https://github.com/ponylang/pony-stable"
  url "https://github.com/ponylang/pony-stable/archive/0.1.0.tar.gz"
  sha256 "131da5897359b68c28a0ff82637f1d668bd34fc2dafead3e8b505fe2611ff003"

  bottle do
    cellar :any_skip_relocation
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
