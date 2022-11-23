class Lolcode < Formula
  desc "Esoteric programming language"
  homepage "http://www.lolcode.org/"
  # NOTE: 0.10.* releases are stable, 0.11.* is dev. We moved over to
  # 0.11.x accidentally, should move back to stable when possible.
  url "https://github.com/justinmeza/lci/archive/v0.11.2.tar.gz"
  sha256 "cb1065936d3a7463928dcddfc345a8d7d8602678394efc0e54981f9dd98c27d2"
  license "GPL-3.0-or-later"
  head "https://github.com/justinmeza/lci.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7bf8def14baaebde0558f5a5d7355d41dc46c1d62ad00fe36bf33b40735c3ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65cf3b809d4ad69918a45976eb04f22f93c785638336e2ae1ba862ef8eeade4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3da1a3ea810fb481b1a6e3e62f81fa5a24ce593b2f69630d6b523a63449531c8"
    sha256 cellar: :any_skip_relocation, ventura:        "6d050e28b462cc3d4466fd98cb7160e589e1efa9c3e163084c16660c8777557a"
    sha256 cellar: :any_skip_relocation, monterey:       "147cc9048722688b7b2744f316db94899843959e1d9a94ce91593087a3e6f1a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "0fe2dd80ac746019da7ebba97a43f010c54ac64fcdff6d87dffffd1e06b43dd3"
    sha256 cellar: :any_skip_relocation, catalina:       "546e86a771457249146ea07ff5669f0e19bd26b3d3e3818ed33925497ae6cfda"
    sha256 cellar: :any_skip_relocation, mojave:         "766522d1d3730e62d1a05e54962b0493db19d62a3cd7ce66328861630508c4ee"
    sha256 cellar: :any_skip_relocation, high_sierra:    "e6cb7d51d26fe4b54f41a14bf183216bb9ca87a6d0b8db25ebf55e64227ac5aa"
    sha256 cellar: :any_skip_relocation, sierra:         "47b268e8334d901868a6498738772b1c776fe34ab249befa702658489e53dff9"
    sha256 cellar: :any_skip_relocation, el_capitan:     "74920cea828644c7ad0fe3b12ee5c9a4c06a46ec37c2826280327e37e30f5513"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb5c917e5a669e5fa18ee60946f30fd1bcbd4a257489e440ba694444f9beaf1d"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "readline"
  end

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
