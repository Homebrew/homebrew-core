class Lolcode < Formula
  desc "Esoteric programming language"
  homepage "https://lolcode.org/"
  # NOTE: 0.10.* releases are stable, 0.11.* is dev. We moved over to
  # 0.11.x accidentally, should move back to stable when possible.
  url "https://github.com/justinmeza/lci/archive/v0.11.2.tar.gz"
  sha256 "cb1065936d3a7463928dcddfc345a8d7d8602678394efc0e54981f9dd98c27d2"
  head "https://github.com/justinmeza/lolcode.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "546e86a771457249146ea07ff5669f0e19bd26b3d3e3818ed33925497ae6cfda" => :catalina
    sha256 "766522d1d3730e62d1a05e54962b0493db19d62a3cd7ce66328861630508c4ee" => :mojave
    sha256 "e6cb7d51d26fe4b54f41a14bf183216bb9ca87a6d0b8db25ebf55e64227ac5aa" => :high_sierra
    sha256 "47b268e8334d901868a6498738772b1c776fe34ab249befa702658489e53dff9" => :sierra
    sha256 "74920cea828644c7ad0fe3b12ee5c9a4c06a46ec37c2826280327e37e30f5513" => :el_capitan
    sha256 "571a57a0fa8b60aac62ce3a358c0b123efcd2af9ec4004c51194c549ad8dd3f1" => :yosemite
    sha256 "9159a0b5f907f400f7e233c026579568dd2c6a98d952fde2759f84cb52101508" => :mavericks
  end

  depends_on "cmake" => :build

  conflicts_with "lci", :because => "both install `lci` binaries"

  def install
    system "cmake", "."
    system "make"
    # Don't use `make install` for this one file
    bin.install "lci"
  end

  test do
    path = testpath/"test.lol"
    path.write <<~EOS
      HAI 1.2
      CAN HAS STDIO?
      VISIBLE "HAI WORLD"
      KTHXBYE
    EOS
    assert_equal "HAI WORLD\n", shell_output("#{bin}/lci #{path}")
  end
end
