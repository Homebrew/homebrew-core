class Packcc < Formula
  desc "Parser generator for C"
  homepage "https://github.com/arithy/packcc"
  url "https://github.com/arithy/packcc/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "b9bea7b2dee2a9bbc4d513a912b52d646556161a4f97e1074c9c9a509f2cc343"
  license "MIT"
  head "https://github.com/arithy/packcc.git", branch: "master"

  bottle do
    sha256 arm64_sequoia:  "aed65253eb5afb1f44bad36b23acd02b0ef5f41e817cba9f284b9753ffc11763"
    sha256 arm64_sonoma:   "34ee3deeba08a37415ff82cd923ce9238e369126ef3197eeca741b4be69ccc10"
    sha256 arm64_ventura:  "e45d252d935dfc169a8d31fd840cde9353b95c5a17f3a9dff48de10961110b7d"
    sha256 arm64_monterey: "8126fe567e6bac3caf32352caefab42b66f46ad53d7cd51a24ef5642d92601a7"
    sha256 sonoma:         "c341e89c607e4e418c4553245ea00881c9b7df52c3c86d66e6e26bbf970433a2"
    sha256 ventura:        "8308b2948c1f811a6a44b507f8c569bebbf1ce4250a5c9558facec5e59296f63"
    sha256 monterey:       "3653656d276ca1dc93c1ea029a43b3b47ac7c5c4e774bf0ce624ae0d5465c071"
    sha256 x86_64_linux:   "b85293be77d9ccaa373653335ec4e2de764f708ffa2910bb0847060186fa3e6e"
  end

  def install
    inreplace "src/packcc.c", "/usr/share/packcc/", "#{pkgshare}/"
    build_dir = buildpath/"build"/ENV.compiler.to_s.sub(/-\d+$/, "")
    system "make", "-C", build_dir
    bin.install build_dir/"release/bin/packcc"
    pkgshare.install "examples", "import"
  end

  test do
    cp pkgshare/"examples/ast-calc.peg", testpath
    system bin/"packcc", "ast-calc.peg"
    system ENV.cc, "ast-calc.c", "-o", "ast-calc"
    output = pipe_output(testpath/"ast-calc", "1+2*3\n")
    assert_equal <<~EOS, output
      binary: "+"
        nullary: "1"
        binary: "*"
          nullary: "2"
          nullary: "3"
    EOS
  end
end
