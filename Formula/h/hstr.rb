class Hstr < Formula
  desc "Bash and zsh history suggest box"
  homepage "https://github.com/dvorka-oss/hstr"
  url "https://github.com/dvorka/hstr/releases/download/v.3.3/hstr-3.3.0-tarball.tgz"
  sha256 "2e030cb0575d57d7d4010602b9bbaa1e7362c11ad349b109f823fad30c69dd10"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ae32ff85108d4355f6ac8b2eca4b147fb615b7a11e575769b518d5663d91bcb6"
    sha256 cellar: :any, arm64_tahoe:       "c0a9127495a86f09c7f828ad8c41dfa8ddce35f33515e9863a44bef64d502554"
    sha256 cellar: :any, arm64_sequoia:     "a05c15326d66c23b9ab18e48f7bc050896fc74c923e605ad759af60b00a1204a"
    sha256 cellar: :any, arm64_linux:       "48bd5ac3b1618d2a789eef3e33315042ad54b0aca05bc0534f4132d95c4fa9e3"
    sha256 cellar: :any, x86_64_linux:      "c060fd8e48b73e4f488d8995ae80c76dcc5a6c2cd02f1aa1ee885f9e5b5d6b6d"
  end

  depends_on "pkgconf" => :build
  depends_on "readline"

  uses_from_macos "ncurses"

  deny_network_access!

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    require "pty"
    require "io/console"

    ENV["HISTFILE"] = testpath/".hh_test"
    (testpath/".hh_test").write("test\n")

    output = ""
    PTY.spawn(bin/"hh", "-n") do |r, _w, _pid|
      r.winsize = [24, 80]
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end
    assert_match "test", output
  end
end
