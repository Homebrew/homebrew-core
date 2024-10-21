class Chrony < Formula
  desc "Versatile implementation of the Network Time Protocol (NTP)"
  homepage "https://chrony-project.org"
  url "https://chrony-project.org/releases/chrony-4.6.1.tar.gz"
  sha256 "571ff73fbf0ae3097f0604eca2e00b1d8bb2e91affe1a3494785ff21d6199c5c"
  license "GPL-2.0-only"

  livecheck do
    url "https://chrony-project.org/download.html"
    regex(/href=.*?chrony[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4c6e88d135fc7248907d23dfeeb0dc7d7d59fdb3e4b4bf5d64cb88cbde144e7b"
    sha256 cellar: :any,                 arm64_sonoma:  "7e9968c5ec5ea5eef8f8e8067102aa76abe5ba51f743ff128ce5a65f77187d38"
    sha256 cellar: :any,                 arm64_ventura: "92e281e61b4343f5e1adc70edfbd7ef37cee3a810f7ebcbaaaee8494095d73e9"
    sha256 cellar: :any,                 sonoma:        "47023cbf95a7711a26f5077d40b0a4564b864fbae5eb7d371952120bb4620d53"
    sha256 cellar: :any,                 ventura:       "a2b6f67ac680be5e10d64b0a8e1c580a64bbd9e53fdabb1b0884562db5b4cef5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55cd6ef009f00d493b55f8ced8b850f4029c6bc9f17e628303d65d4391df69d4"
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "nettle"

  uses_from_macos "libedit"

  def install
    system "./configure", "--localstatedir=#{var}", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.conf").write "pool pool.ntp.org iburst\n"
    output = shell_output(sbin/"chronyd -Q -f #{testpath}/test.conf 2>&1")
    assert_match(/System clock wrong by -?\d+\.\d+ seconds \(ignored\)/, output)
  end
end
