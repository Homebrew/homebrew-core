class ErlangLs < Formula
  desc "Erlang Language Server"
  homepage "https://erlang-ls.github.io/"
  url "https://github.com/erlang-ls/erlang_ls/archive/refs/tags/0.52.0.tar.gz"
  sha256 "8c9028cc65985746abc8736703381c04f0922116ef8cc7711bee09953432d968"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bfe87d824cde6cf16b8f5cbf1a42231bcc6e372857e5b4c76633da319f42a0b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26c849a25c59140975a92ecf66c93b1ef4c992e4c28b24f543cdd8a67fc70d0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c6bf7e219d2257764f730c449740df177e3199a81905bc90db041b0c16137ad"
    sha256 cellar: :any_skip_relocation, sonoma:         "0bb7dd3df411c3c1c0caa939799f3f478e1713298377bf3ddc14242b271d4c2c"
    sha256 cellar: :any_skip_relocation, ventura:        "3afd0511e67087ca326caddc9201f3601ac421064f7996963ee2908729caeb42"
    sha256 cellar: :any_skip_relocation, monterey:       "96555d73088bc734d656a4c5f8688ea27d2b19a48f19176952aba028cf36257a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "221ac9e5a40d613351cbfe50493670f09750d609368ddff6dcec09cc50c2cf70"
  end

  depends_on "erlang"
  depends_on "rebar3"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    output = pipe_output("#{bin}/erlang_ls", nil, 1)
    assert_match "Content-Length", output
  end
end
