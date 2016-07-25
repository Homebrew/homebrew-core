class Lolcode < Formula
  desc "Esoteric programming language"
  homepage "http://lolcode.org"
  # NOTE: 0.10.* releases are stable, 0.11.* is dev. We moved over to
  # 0.11.x accidentally, should move back to stable when possible.
  url "https://github.com/justinmeza/lci/archive/v0.11.2.tar.gz"
  sha256 "cb1065936d3a7463928dcddfc345a8d7d8602678394efc0e54981f9dd98c27d2"
  head "https://github.com/justinmeza/lolcode.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "74920cea828644c7ad0fe3b12ee5c9a4c06a46ec37c2826280327e37e30f5513" => :el_capitan
    sha256 "571a57a0fa8b60aac62ce3a358c0b123efcd2af9ec4004c51194c549ad8dd3f1" => :yosemite
    sha256 "9159a0b5f907f400f7e233c026579568dd2c6a98d952fde2759f84cb52101508" => :mavericks
    sha256 "28fb518f1ae0311dcd2c77529a8bf8450b6e0947d95db6a243598f08a335a683" => :mountain_lion
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
    path.write <<-EOS.undent
      HAI 1.2
      CAN HAS STDIO?
      VISIBLE "HAI WORLD"
      KTHXBYE
    EOS
    assert_equal "HAI WORLD\n", shell_output("#{bin}/lci #{path}")
  end
end
