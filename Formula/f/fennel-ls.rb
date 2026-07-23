class FennelLs < Formula
  desc "Language Server for Fennel"
  homepage "https://git.sr.ht/~xerool/fennel-ls/"
  url "https://git.sr.ht/~xerool/fennel-ls/archive/0.2.4.tar.gz"
  sha256 "d50a48e2c65e84c87694cf7fd142ffcfc3a573567a1610a0b1accb97930ee2d5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9934b9c9d2df6da8693af31de78af5146777a2ba90bf6f6e57d9ba33d274a09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9934b9c9d2df6da8693af31de78af5146777a2ba90bf6f6e57d9ba33d274a09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9934b9c9d2df6da8693af31de78af5146777a2ba90bf6f6e57d9ba33d274a09"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9934b9c9d2df6da8693af31de78af5146777a2ba90bf6f6e57d9ba33d274a09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9934b9c9d2df6da8693af31de78af5146777a2ba90bf6f6e57d9ba33d274a09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d21888a8352b783653791b7acd6f72be608c6389bc76054456b5796924707a8"
  end

  depends_on "pandoc" => :build
  depends_on "lua"

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fennel-ls --version")

    (testpath/"test.fnl").write <<~FENNEL
      { foo }
    FENNEL

    expected = "test.fnl:1:6: error: expected even number of values in table literal"
    assert_match expected, shell_output("#{bin}/fennel-ls --lint test.fnl 2>&1", 1)
  end
end
