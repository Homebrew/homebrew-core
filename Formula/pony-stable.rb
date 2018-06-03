class PonyStable < Formula
  desc "Dependency manager for the Pony language"
  homepage "https://github.com/ponylang/pony-stable"
  url "https://github.com/ponylang/pony-stable/archive/0.1.3.tar.gz"
  sha256 "75b40a965469865aa3bf9b2f791fc641cb92854ba718d3bd66c68764cd20b16c"

  bottle do
    cellar :any_skip_relocation
    sha256 "32cdd84d8c1a3c4111e49f03c5d0e6100051b2a3bf27b8dcc8538e845e9b173a" => :high_sierra
    sha256 "7f39df064bfda4f2f8d9d8c1661a194693721e177a28e92ac2bb42af77207dee" => :sierra
    sha256 "7ac543ad7b0a83b8a34320ce062ded8d9a9fceb55e94e723b532f33b8767b0bf" => :el_capitan
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
