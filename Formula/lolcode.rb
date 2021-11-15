class Lolcode < Formula
  desc "Esoteric programming language"
  homepage "http://www.lolcode.org/"
  # NOTE: 0.10.* releases are stable, 0.11.* is dev. We moved over to
  # 0.11.x accidentally, should move back to stable when possible.
  url "https://github.com/justinmeza/lci/archive/v0.11.2.tar.gz"
  sha256 "cb1065936d3a7463928dcddfc345a8d7d8602678394efc0e54981f9dd98c27d2"
  license "GPL-3.0"
  head "https://github.com/justinmeza/lolcode.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65cf3b809d4ad69918a45976eb04f22f93c785638336e2ae1ba862ef8eeade4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3da1a3ea810fb481b1a6e3e62f81fa5a24ce593b2f69630d6b523a63449531c8"
    sha256 cellar: :any_skip_relocation, monterey:       "147cc9048722688b7b2744f316db94899843959e1d9a94ce91593087a3e6f1a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "0fe2dd80ac746019da7ebba97a43f010c54ac64fcdff6d87dffffd1e06b43dd3"
    sha256 cellar: :any_skip_relocation, catalina:       "546e86a771457249146ea07ff5669f0e19bd26b3d3e3818ed33925497ae6cfda"
    sha256 cellar: :any_skip_relocation, mojave:         "766522d1d3730e62d1a05e54962b0493db19d62a3cd7ce66328861630508c4ee"
    sha256 cellar: :any_skip_relocation, high_sierra:    "e6cb7d51d26fe4b54f41a14bf183216bb9ca87a6d0b8db25ebf55e64227ac5aa"
    sha256 cellar: :any_skip_relocation, sierra:         "47b268e8334d901868a6498738772b1c776fe34ab249befa702658489e53dff9"
    sha256 cellar: :any_skip_relocation, el_capitan:     "74920cea828644c7ad0fe3b12ee5c9a4c06a46ec37c2826280327e37e30f5513"
    sha256 cellar: :any_skip_relocation, yosemite:       "571a57a0fa8b60aac62ce3a358c0b123efcd2af9ec4004c51194c549ad8dd3f1"
  end

  depends_on "cmake" => :build

  conflicts_with "lci", because: "both install `lci` binaries"

  def install
    system "cmake", ".", *std_cmake_args
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
