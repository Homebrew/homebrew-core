class PonyStable < Formula
  desc "Dependency manager for the Pony language"
  homepage "https://github.com/ponylang/pony-stable"
  url "https://github.com/ponylang/pony-stable/archive/0.1.1.tar.gz"
  sha256 "59be7487dd979e5da6a361ed06f98606d4efb2e5ddccdcf0514a082261873d8d"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc86a34ea00d54295b571e1159547bc2e912d9c7763c53421a2dc27da266b4b6" => :high_sierra
    sha256 "16bcd6c5571e6a386da13030b527949487a52411b0d927a6be49cd5b659de7e4" => :sierra
    sha256 "6442471350ad0298c6ecef6be1f49fd16e5b5b8c147e31eb210db329fb81b73e" => :el_capitan
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
