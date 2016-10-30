class Monotone < Formula
  desc "Distributed version control system (DVCS)"
  homepage "http://monotone.ca/"
  url "http://www.monotone.ca/downloads/1.1/monotone-1.1.tar.bz2"
  sha256 "f95cf60a22d4e461bec9d0e72f5d3609c9a4576fb1cc45f553d0202ce2e38c88"
  revision 1

  bottle do
    rebuild 1
    sha256 "43c1c8d4e74515141d33d3035ab6fc69cf15c948e6f833ca8d5d60e4f6348c2a" => :sierra
    sha256 "fa3f3da7abae328d91c2c8da3aaedd3dfd955ba76ab30bab7edbd592654e9e01" => :el_capitan
    sha256 "9ec274bfec3311fb327dbf699b28c77166422920e8cff252c8d8beecd98c9a4a" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libidn"
  depends_on "lua"
  depends_on "pcre"
  depends_on "botan"
  # Monotone only needs headers, not any built libraries
  depends_on "boost" => :build

  fails_with :llvm do
    build 2334
    cause "linker fails"
  end

  def install
    botan = Formula["botan"]

    ENV["botan_CFLAGS"] = "-I#{botan.opt_include}/botan-1.10"
    ENV["botan_LIBS"] = "-L#{botan.opt_lib} -lbotan-1.10"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    # Explicitly remove the bash completion script, as it uses features
    # specific to Bash 4, and the default on macOS is Bash 3.
    # Specifically, it uses `declare -A` to declare associate arrays.
    # If this completion script is installed on Bash 3 along with
    # bash-completion, it will be auto-sourced and cause error messages
    # every time a new terminal is opened. See:
    # https://github.com/Homebrew/homebrew/issues/29272
    rm prefix/"etc/bash_completion.d/monotone.bash_completion"
  end
end
