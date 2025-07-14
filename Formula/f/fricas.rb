class Fricas < Formula
  desc "Advanced computer algebra system"
  homepage "https://fricas.github.io"
  url "https://github.com/fricas/fricas/archive/refs/tags/1.3.12.tar.gz"
  sha256 "f201cf62e3c971e8bafbc64349210fbdc8887fd1af07f09bdcb0190ed5880a90"
  license "BSD-3-Clause"
  head "https://github.com/fricas/fricas.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7fbe73c52677676edec374061a9889381f7b8dd79d231cd5db743e8b47b83be4"
    sha256 cellar: :any,                 arm64_sonoma:  "f80b27d9b594c6161a4b882f13cdb0c62f883d42760bb62d8563791d3ce3660b"
    sha256 cellar: :any,                 arm64_ventura: "e78686fad2f37772d9d575453720622bd63af29ecc888a369672b14f2ca3e1d7"
    sha256 cellar: :any,                 sonoma:        "716ba2734fc10c1a9540e8b868bfa6ff05c0ff8fa07fc04582808e2c12efb999"
    sha256 cellar: :any,                 ventura:       "a3737a559b67fb9d5887f00208bf6c56b0e444d8f88be2d627db873c6971fde9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22865967ea74382926e358484cef468d9eda01c3b251ee98ac8bdcb0095f47db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f35e32107cab4e45364c7f07245b562c6a425283ec655a22214a2c6f8302e8a2"
  end

  depends_on "gmp"
  depends_on "libice"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxau"
  depends_on "libxdmcp"
  depends_on "libxpm"
  depends_on "libxt"
  depends_on "sbcl"
  depends_on "zstd"

  def install
    args = [
      "--with-lisp=sbcl",
      "--enable-gmp",
    ]

    mkdir "build" do
      system "../configure", *std_configure_args, *args
      system "make"
      system "make", "install"
    end
  end

  test do
    # Fails in Linux CI with "Can't find sbcl.core"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match %r{ \(/ \(pi\) 2\)\n},
      pipe_output(bin/"fricas -nosman", "integrate(sqrt(1-x^2),x=-1..1)::InputForm")
  end
end
