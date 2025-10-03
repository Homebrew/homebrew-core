class Lolcode < Formula
  desc "Esoteric programming language"
  homepage "http://www.lolcode.org/"
  # NOTE: 0.10.* releases are stable, 0.11.* is dev. We moved over to
  # 0.11.x accidentally, should move back to stable when possible.
  url "https://github.com/justinmeza/lci/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "cb1065936d3a7463928dcddfc345a8d7d8602678394efc0e54981f9dd98c27d2"
  license "GPL-3.0-or-later"
  head "https://github.com/justinmeza/lci.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "1eb6ed26315bf0661ada71178ff3d2cc437e374614f4162fe5327f060b255763"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8c4074b5d6a8c5412c5be4a9cfc5c2ee4ab4e5ac12338fdd05141d98fbcea538"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "41bf236e028b388c85213b0e45f10fa83aea6c4b283c96f86426313646424a52"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7bf8def14baaebde0558f5a5d7355d41dc46c1d62ad00fe36bf33b40735c3ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65cf3b809d4ad69918a45976eb04f22f93c785638336e2ae1ba862ef8eeade4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3da1a3ea810fb481b1a6e3e62f81fa5a24ce593b2f69630d6b523a63449531c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a28a3eac2937e9e8a36e92f3fd592b53efd1c9aa65965986603e5b90f0dc2cc"
    sha256 cellar: :any_skip_relocation, ventura:        "6d050e28b462cc3d4466fd98cb7160e589e1efa9c3e163084c16660c8777557a"
    sha256 cellar: :any_skip_relocation, monterey:       "147cc9048722688b7b2744f316db94899843959e1d9a94ce91593087a3e6f1a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "0fe2dd80ac746019da7ebba97a43f010c54ac64fcdff6d87dffffd1e06b43dd3"
    sha256 cellar: :any_skip_relocation, catalina:       "546e86a771457249146ea07ff5669f0e19bd26b3d3e3818ed33925497ae6cfda"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e3b96d74e84ab5da91383bcd19579be2b02dd7da68a240f2d8685195d80ffa21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb5c917e5a669e5fa18ee60946f30fd1bcbd4a257489e440ba694444f9beaf1d"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "readline"
  end

  conflicts_with "lci", because: "both install `lci` binaries"

  # Backport fix for CMake 4 compatibility
  patch do
    url "https://github.com/justinmeza/lci/commit/42ac17a22ddce737664b39a50442e6623a7e51a2.patch?full_index=1"
    sha256 "03b8a8bd907501818d0c7b71444727e6a49143aabd280966bfb5eab7d9fe3fc6"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"

    # Don't use `make install` for this one file
    bin.install "build/lci"
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
