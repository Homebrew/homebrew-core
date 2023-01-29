class Dmagnetic < Formula
  desc "Magnetic Scrolls Interpreter"
  homepage "https://www.dettus.net/dMagnetic/"
  url "https://www.dettus.net/dMagnetic/dMagnetic_0.36.tar.bz2"
  sha256 "0b7614e47f6711ce58cfbee7188d56d17a92c104004f51ab61798b318e897d8f"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?dMagnetic[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "e6940319b967507415be3bddd0be0d55371b443e1e2aa19a632d86e2c6053166"
    sha256 arm64_monterey: "0a62644ba3abf82e6e81780ba4717b29cca1fd95055f7296bce848f1dbba4fe7"
    sha256 arm64_big_sur:  "c023ef0b64d06d0725b153116d921ed32bd5af504ca15c4e759ff313091b7d92"
    sha256 ventura:        "d23f362dd896c05e7c26cbfd6fa4d6c9941e3752bd851d3ca915eaa1d336ddb4"
    sha256 monterey:       "f8b059c4cd374854eb806e8467633dd7ac9e624dbf8832d842d9a79ce22245ab"
    sha256 big_sur:        "f1f89777da204a7e8eaa16cf9ded1c5abb40d9f30ee17c3d3b548dd910671a29"
    sha256 x86_64_linux:   "d3fcb77de41a65ff5d9ef566fc12593008821bd61a85ea03f1e1e2e5b2bff371"
  end

  def install
    # Look for configuration and other data within the Homebrew prefix rather than the default paths
    inreplace "src/frontends/default/pathnames.h" do |s|
      s.gsub! "/etc/", "#{etc}/"
      s.gsub! "/usr/local/", "#{HOMEBREW_PREFIX}/"
    end

    system "make", "PREFIX=#{prefix}", "install"
    (share/"games/dMagnetic").install "testcode/minitest.mag", "testcode/minitest.gfx"
  end

  test do
    args = %W[
      -vmode none
      -vcols 300
      -vrows 300
      -vecho -sres 1024x768
      -mag #{share}/games/dMagnetic/minitest.mag
      -gfx #{share}/games/dMagnetic/minitest.gfx
    ]
    command_output = pipe_output("#{bin}/dMagnetic #{args.join(" ")}", "Hello\n")
    assert_match(/^Virtual machine is running\..*\n> HELLO$/, command_output)
  end
end
