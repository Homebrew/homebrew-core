class Dmagnetic < Formula
  desc "Magnetic Scrolls Interpreter"
  homepage "https://www.dettus.net/dMagnetic/"
  url "https://www.dettus.net/dMagnetic/dMagnetic_0.34.tar.bz2"
  sha256 "570b1beb7111874cfbb54fc71868dccc732bc3235b9e5df586d93a4ff2b8e897"
  license "BSD-2-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?dMagnetic[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "5b7c0c396302a2a58e6d2c4d3547653b622a2ce4dbd1b138382f020545a4c560"
    sha256 arm64_monterey: "d5e92d330c580d50b50e4a9abeabe07c8d03c34b7119ceeae28bdd4dfbd48d0e"
    sha256 arm64_big_sur:  "dfdc741291733bee64c506d1c381ee968ba6b53836b4a5d0428ae92b92cdf914"
    sha256 ventura:        "1d9841ba3b46f8108381a342ce8e66453323ad42022418c76b68ee087768160b"
    sha256 monterey:       "80776cb548df431c030a17e6880e28ba3d15e1fbc6aa7deed5c9de54f4b559b0"
    sha256 big_sur:        "536f7efb82b7d9d981b277e2ff2ce23dbcd7c3be3527f336376a50e3b9b3dcd7"
    sha256 catalina:       "702f73e365edc401d40fb8c9b913531063ba145e839027d6ad7e55356bd10483"
    sha256 x86_64_linux:   "b672f707385a493c0fd20a51a4fd579411c5eaffbb599b418e5f9e5bf66147ee"
  end

  def install
    # Look for configuration and other data within the Homebrew prefix rather than the default paths
    inreplace "src/toplevel/dMagnetic_pathnames.h" do |s|
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
