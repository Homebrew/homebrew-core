class Hstr < Formula
  desc "Bash and zsh history suggest box"
  homepage "https://github.com/dvorka-oss/hstr"
  url "https://github.com/dvorka-oss/hstr/releases/download/v3.2/hstr-3.2.0-tarball.tgz"
  sha256 "abf0a8625545b2022d62bf0d1c576e3cc783c4ea7cc2ae2843c518743f77f4c9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "8d1fa37547c3effc10a78bf346c7223ac1807bb4e16fc5f7aca73fea7a4a265c"
    sha256 cellar: :any,                 arm64_tahoe:       "9348756624b912bde30a667b01d54dc146823647642f16783fd43b64172d19c1"
    sha256 cellar: :any,                 arm64_sequoia:     "5c3cfaae97f048b41e25d9d79f9f2951bba6593872b13cab543ae5ec2c8518ef"
    sha256 cellar: :any,                 arm64_sonoma:      "12764e0b6619fd95dcc2568ba75aea2629cea3fa11039acda82fd1cd4d55f0b2"
    sha256 cellar: :any,                 sonoma:            "bb7c70afe249596ea8ddc54273638cce6f2bd59bc7e88680e922bd99f3e279cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3c0f07a862b669a185a4da02d995fd01ff12d19945b3628e09c2f59b5a7d7a97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8b95920a4bed1c587f8c86e4d3e520ca1849da7cd53107c6890459c7763dca43"
  end

  depends_on "pkgconf" => :build
  depends_on "readline"

  uses_from_macos "ncurses"

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
