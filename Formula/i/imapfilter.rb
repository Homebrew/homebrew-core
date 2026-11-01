class Imapfilter < Formula
  desc "IMAP message processor/filter"
  homepage "https://github.com/lefcha/imapfilter/"
  url "https://github.com/lefcha/imapfilter/archive/refs/tags/v2.8.6.tar.gz"
  sha256 "380bc0848002aadb074ade86f2fe3f5b62612a378173f2b10043527d31f13aeb"
  license "MIT"

  bottle do
    sha256 arm64_golden_gate: "48e26b4902a45d642f75415357e62d453bda32b8a27a0e2c229c207f53d6235a"
    sha256 arm64_tahoe:       "8b8f69bd94c85c52788b590fbee351bc5ff704ccb0ebbe9e11fc2a2a78b9d3f2"
    sha256 arm64_sequoia:     "40e1c8d5263e657d0944a308a6aee9b8f2affefa4f9f282598eef4e2bdacc826"
    sha256 arm64_linux:       "48ab64c893cc06729518c4bf41203da3eb745a80bfee02e2856f143098c5eae7"
    sha256 x86_64_linux:      "5ead653172e238a390b43121d16f3ee7295287a8385d49745b2b7b91d4d98337"
  end

  depends_on "lua"
  depends_on "openssl@4"
  depends_on "pcre2"

  deny_network_access!

  def install
    # find Homebrew's libpcre and lua
    ENV.append "CPPFLAGS", "-I#{formula_opt_include("lua")}/lua"
    ENV.append "LDFLAGS", "-L#{formula_opt_lib("pcre2")}"
    ENV.append "LDFLAGS", "-L#{formula_opt_lib("lua")}"
    ENV.append "LDFLAGS", "-liconv" if OS.mac?
    system "make", "PREFIX=#{prefix}", "MANDIR=#{man}", "MYCFLAGS=#{ENV.cflags}", "MYLDFLAGS=#{ENV.ldflags}"
    system "make", "PREFIX=#{prefix}", "MANDIR=#{man}", "install"

    prefix.install "samples"
  end

  def caveats
    <<~EOS
      You will need to create a ~/.imapfilter/config.lua file.
      Samples can be found in:
        #{prefix}/samples
    EOS
  end

  test do
    system bin/"imapfilter", "-V"
  end
end
