class Mfterm < Formula
  desc "Terminal for working with Mifare Classic 1-4k Tags"
  homepage "https://github.com/4ZM/mfterm"
  url "https://github.com/4ZM/mfterm/releases/download/v1.0.7/mfterm-1.0.7.tar.gz"
  sha256 "b6bb74a7ec1f12314dee42973eb5f458055b66b1b41316ae0c5380292b86b248"
  license "GPL-3.0-or-later"
  revision 3

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "e0f593b5e2b34ba00dd11867d7492b51988e9831a58232bf62dec2bbef789a13"
    sha256 cellar: :any, arm64_tahoe:       "60aeea82c7d8adad403b01a6ac6360429e5761b88d6d8f5c8f613c7da808d656"
    sha256 cellar: :any, arm64_sequoia:     "518dfba132ced0ec7b8f2fed7c11b9bbaec98fa31bac1a95814d369ab4344655"
    sha256 cellar: :any, arm64_linux:       "d8ce19d5e8970f9169534e685f93fd44c2b0f786952851fea09a456a7ff06318"
    sha256 cellar: :any, x86_64_linux:      "c7e2d26924345300a3dc724214e1be9b0b34bf520bb0bb934959836549149b63"
  end

  head do
    url "https://github.com/4ZM/mfterm.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libnfc"
  depends_on "openssl@4"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "readline"
  end

  deny_network_access!

  def openssl = deps.map(&:name).find { |d| d.match?(/^openssl(@\d+(\.\d+)*)?$/) }

  def install
    ENV.prepend "CPPFLAGS", "-I#{formula_opt_include(openssl)}"
    ENV.prepend "LDFLAGS", "-L#{formula_opt_lib(openssl)}"

    if build.head?
      chmod 0755, "./autogen.sh"
      system "./autogen.sh"
    end
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"mfterm", "--version"
  end
end
