class Fennel < Formula
  desc "Lua Lisp Language"
  homepage "https://fennel-lang.org"
  url "https://github.com/bakpakin/Fennel/archive/1.1.0.tar.gz"
  sha256 "14873fb319ace8707a075bc4696d3691f5045686e5738822bdf4cc014d14b4b8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45a17c2e474fdd8c601ea77e5bc52d2c2e07b094d99916872952b1646bbcf5fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "113bcdf641420a750971fd68048300eedc034153840e00ccd898ff5dd6e14569"
    sha256 cellar: :any_skip_relocation, monterey:       "acc0ef368c737bc11e0f1aaf50d05812113c7203b3da04471d73f53e91045517"
    sha256 cellar: :any_skip_relocation, big_sur:        "55673aafb83cb341ab0d09b6ac85306718714112b72248c71ee8cd3e999e83bd"
    sha256 cellar: :any_skip_relocation, catalina:       "cf4789db2ba53d5a6521853646195b3a9ad51c7ca5146cf005abe38e3e496ef9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf4e121f4b4e5c9e7b1af9942ae1be720ea167edb1d45b95bec89ddcbc00a18a"
  end

  depends_on "lua"

  def install
    system "make"
    bin.install "fennel"

    lua = Formula["lua"]
    (share/"lua"/lua.version.major_minor).install "fennel.lua"
  end

  test do
    assert_match "hello, world!", shell_output("#{bin}/fennel -e '(print \"hello, world!\")'")
  end
end
