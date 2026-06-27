class Ctpv < Formula
  desc "Image previews for lf file manager"
  homepage "https://www.nikitaivanov.com/man1/ctpv"
  url "https://github.com/NikitaIvanovV/ctpv/archive/refs/tags/v1.1.tar.gz"
  sha256 "29e458fbc822e960f052b47a1550cb149c28768615cc2dddf21facc5c86f7463"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4255d6a7a1a4b093609a9b614adaaacf563011c758916c1c3aa804defbe89e93"
    sha256 cellar: :any,                 arm64_sequoia: "7dd57d5d3080b7ed19c8cd9b27bd26673ad2ce6df9ae1543a449f62820284cdc"
    sha256 cellar: :any,                 arm64_sonoma:  "3afc3e19e6d42a56723344456a005cb43f0ea91a30b6fd7b8123a42fe40ee8cd"
    sha256 cellar: :any,                 sonoma:        "c2d0711117c2451fd739091152c5098e2cfb07881f2b25f791475c28819a3cfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee9c91478a3c912d51de6a67e22ca99f97b549e933ceddf535b0582f85b20a58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "899ad1cf4f12ee2219a694446219373d81b5c9274087c7e1797a4cca2f5a5bc7"
  end

  depends_on "libmagic"
  depends_on "openssl@4"

  fails_with :clang do
    build 1300
    cause "Requires Clang 14 or later"
  end

  def install
    # Workaround for arm64 linux, issue ref: https://github.com/NikitaIvanovV/ctpv/issues/101
    ENV.append_to_cflags "-fsigned-char" if OS.linux? && Hardware::CPU.arm?

    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    file = test_fixtures("test.diff")
    output = shell_output("#{bin}/ctpv #{file}").gsub(/\e\[[\d;]*m/, "")
    assert_match shell_output("cat #{file}"), output
  end
end
