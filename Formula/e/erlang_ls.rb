class ErlangLs < Formula
  desc "Erlang Language Server"
  homepage "https://erlang-ls.github.io/"
  url "https://github.com/erlang-ls/erlang_ls/archive/refs/tags/1.1.0.tar.gz"
  sha256 "b826edae46219a90ab6a162be1626e2f4b0fd60cb2f3372d7a171ee3921aebf0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9514306a369f354ad922a5b9406b67a141a8da78c1eb8c39419b2ff60a4bc2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc89472e09f589b8a7f2fce292740b647bbd99f2dab7270cda175c942d74abcb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f2307d98a124af2ff6ea5e9289f3de2cc0f40e9efa97d68874e90cdcad09a26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "16b38a612902bccc962a17a08195f2eed0c1f2bf73653a19c6e19262af63cf96"
    sha256 cellar: :any_skip_relocation, sonoma:        "c25d4a54ebfdb777c9845e87962815e609269cbc0e5fa012e1e97bc8d5fdd510"
    sha256 cellar: :any_skip_relocation, ventura:       "555f68cb1034010a6915ccc739262e4e3e731d0f92cf0c0d88e3743ad874616d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6aba7332a63a33fdd10210d0b3c7bab5492501ef807cbae0a3a0c08495b99d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c68b4f50a62cb9956ba11796d8c0f38ba88cdefc1977af46f8a7871c60f402a"
  end

  depends_on "erlang"
  depends_on "rebar3"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    output = pipe_output(bin/"erlang_ls", nil, 1)
    assert_match "Content-Length", output
  end
end
