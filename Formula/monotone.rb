class Monotone < Formula
  desc "Distributed version control system (DVCS)"
  homepage "https://www.monotone.ca/"
  url "https://www.monotone.ca/downloads/1.1/monotone-1.1.tar.bz2"
  sha256 "f95cf60a22d4e461bec9d0e72f5d3609c9a4576fb1cc45f553d0202ce2e38c88"
  revision 2

  bottle do
    sha256 "ddddc2d6b0bb81de9c98cf465170a66f6a49a580ce607488fd13375ec39fb5ba" => :sierra
    sha256 "19f100a72e505d05bd6debdc040fd00718ce16c45526ca7fd054f4b337ce2481" => :el_capitan
    sha256 "108346a69201f7692b7e421026202d718fe5bb145ab1b24c0ddf070a5c58d7a8" => :yosemite
  end

  # Monotone only needs Boost headers, not any built libraries
  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libidn"
  depends_on "lua"
  depends_on "pcre"
  # For the vendored Botan.
  depends_on "openssl"

  resource "old_botan" do
    url "https://botan.randombit.net/releases/Botan-1.10.15.tgz"
    sha256 "c0cc8ffd470fda4b257c3ef9faf5cf93751f4c283dfba878148acafedfab70fe"
  end

  def install
    botan = libexec/"vendor/old_botan"
    resource("old_botan").stage do
      inreplace "src/build-data/makefile/unix_shr.in" do |s|
        s.gsub! "= $(LIBNAME)-$(SERIES).%{so_suffix}.%{so_abi_rev}",
                "= $(LIBNAME)-$(SERIES).%{so_abi_rev}.%{so_suffix}"
        s.gsub! "= $(SONAME).%{version_patch}",
                "= $(LIBNAME)-$(SERIES).%{so_abi_rev}.%{version_patch}.%{so_suffix}"
      end

      system "./configure.py", "--prefix=#{botan}",
                               "--docdir=share/doc",
                               "--cpu=#{MacOS.preferred_arch}",
                               "--cc=#{ENV.compiler}",
                               "--os=darwin",
                               "--with-openssl",
                               "--with-zlib",
                               "--with-bzip2"
      system "make", "install", "MACH_OPT=#{ENV.cflags}"
    end

    ENV["botan_CFLAGS"] = "-I#{botan}/include/botan-1.10"
    ENV["botan_LIBS"] = "-L#{botan}/lib -lbotan-1.10"

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

  test do
    assert_match version.to_s, shell_output("#{bin}/mtn --version")
  end
end
