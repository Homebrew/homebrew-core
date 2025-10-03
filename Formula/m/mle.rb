class Mle < Formula
  desc "Flexible terminal-based text editor"
  homepage "https://github.com/adsr/mle"
  url "https://github.com/adsr/mle/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "5275fcfc58d3d4890d074077d94497db488b2648287b3e48e67b00ea517b02ba"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "f6b25000e7a6c630e4d82f5dbab514057fb7c07a419faea456ac3d732d304b29"
    sha256 cellar: :any,                 arm64_sequoia:  "800c452587c4c4ba8e4d97f36ce15a896b8be362999407378bc05a7f7089252a"
    sha256 cellar: :any,                 arm64_sonoma:   "c98cff80d60ca797855ae9258e40629692dc0faadfe49b7de393bfece8cc6d44"
    sha256 cellar: :any,                 arm64_ventura:  "ddeba783462112b24a7d5fbb7c29630207fdbb51a673ce8ec92faf612c4f077d"
    sha256 cellar: :any,                 arm64_monterey: "056a20a65b133842b690b2fdc939fe6895701c465853fdfbcc48d0a17e6002f2"
    sha256 cellar: :any,                 arm64_big_sur:  "d40a5279f04a3104a425a739b3f734fcca7abd025f2510c078684cbc910f2f86"
    sha256 cellar: :any,                 sonoma:         "ca38a92ae7ab39d9ad4491a46dade0582561c5cb0744634fd07372a545842bc5"
    sha256 cellar: :any,                 ventura:        "50f5723f83057f3e3ff647cfa5a7de27757dc30bf7f95be6cfe8b4be663648a5"
    sha256 cellar: :any,                 monterey:       "e12c72f828b8b070527cafc5a54fdd1dfc4bd9b2200f235fba457785de2b62c3"
    sha256 cellar: :any,                 big_sur:        "493774af04dcfd335301a1845db88772a9b100fa8f4478f891ca5c9ad4e09c05"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e7b03071021e45985a48a467283493de9d598dc94ec0b758db4bcc7bac413b5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b163c0cdfde98734db406062d8f829d2c64d178c31ef3b7dad8ca75619e58cc5"
  end

  depends_on "uthash" => :build
  depends_on "lua"
  depends_on "pcre2"

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    output = pipe_output("#{bin}/mle -M 'test C-e space w o r l d enter' -p test", "hello")
    assert_equal "hello world\n", output
  end
end
