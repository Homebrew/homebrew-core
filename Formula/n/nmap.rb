class Nmap < Formula
  include Language::Python::Virtualenv

  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  url "https://nmap.org/dist/nmap-7.97.tar.bz2"
  sha256 "af98f27925c670c257dd96a9ddf2724e06cb79b2fd1e0d08c9206316be1645c0"
  license :cannot_represent
  head "https://svn.nmap.org/nmap/"

  livecheck do
    url "https://nmap.org/download"
    regex(/href=.*?nmap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "50ff67cd6a9106fd4813f23563e93afb1c010e72d2440210547ab1e85a9a2f8b"
    sha256 arm64_sonoma:  "903b327e4d5670592fce8006045465c25f4906860124a6fadd09c8c6f075173d"
    sha256 arm64_ventura: "ea8100a4be7170fc892f4b07ae93c6a783cdf4b73637f8bc6b77e70e1a3da9e2"
    sha256 sonoma:        "29886e3599134f930e515d864133d5560ca4fa6688683d6d6651a3e74659bd1e"
    sha256 ventura:       "7960ae55e221cd465ec9c81bab21c68e3deba12a42ba54a062b5a7357d8aedf2"
    sha256 arm64_linux:   "ba802ad8db113e38cb97d0052043909b48fe830ba6ba4fd5ff17dedfd3a5b564"
    sha256 x86_64_linux:  "6d61d459f9d25a07da0695b7c6be96392fcb8f662babb6bedb64b371575da6d5"
  end

  depends_on "python@3.13" => :build
  depends_on "liblinear"
  depends_on "libssh2"
  # Check supported Lua version at https://github.com/nmap/nmap/tree/master/liblua.
  depends_on "lua"
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "libpcap"
  uses_from_macos "zlib"

  conflicts_with "cern-ndiff", "ndiff", because: "both install `ndiff` binaries"
  conflicts_with "nping", because: "both install `nping` binaries"
  conflicts_with cask: "zenmap", because: "both install `nmap` binaries"

  resource "build" do
    url "https://files.pythonhosted.org/packages/7d/46/aeab111f8e06793e4f0e421fcad593d547fb8313b50990f31681ee2fb1ad/build-1.2.2.post1.tar.gz"
    sha256 "b36993e92ca9375a219c99e606a122ff365a760a2d4bba0caa09bd5278b608b7"
  end

  resource "pyproject-hooks" do
    url "https://files.pythonhosted.org/packages/e7/82/28175b2414effca1cdac8dc99f76d660e7a4fb0ceefa4b4ab8f5f6742925/pyproject_hooks-1.2.0.tar.gz"
    sha256 "1e859bd5c40fae9448642dd871adf459e5e2084186e8d2c2a79a824c970da1f8"
  end

  def install
    python3 = "python3.13"
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install resources
    ENV["PYTHON"] = buildpath/"venv/bin/python"
    # Fix to missing VERSION file
    # https://github.com/nmap/nmap/pull/3111
    mv "libpcap/VERSION.txt", "libpcap/VERSION"

    ENV.deparallelize

    libpcap_path = if OS.mac?
      MacOS.sdk_path/"usr/"
    else
      Formula["libpcap"].opt_prefix
    end

    args = %W[
      --with-liblua=#{Formula["lua"].opt_prefix}
      --with-libpcre=#{Formula["pcre2"].opt_prefix}
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
      --with-libpcap=#{libpcap_path}
      --without-nmap-update
      --disable-universal
      --without-zenmap
    ]

    system "./configure", *args, *std_configure_args
    system "make" # separate steps required otherwise the build fails
    system "make", "install"

    bin.glob("uninstall_*").map(&:unlink) # Users should use brew uninstall.
    return unless (bin/"ndiff").exist? # Needs Python

    # We can't use `rewrite_shebang` here because `detected_python_shebang` only works
    # for shebangs that start with `/usr/bin`, but the shebang we want to replace
    # might start with `/Applications` (for the `python3` inside Xcode.app).
    inreplace bin/"ndiff", %r{\A#!.*/python(\d+(\.\d+)?)?$}, "#!/usr/bin/env python3"
  end

  def caveats
    on_macos do
      <<~EOS
        If using `ndiff` returns an error about not being able to import the ndiff module, try:
          chmod go-w #{HOMEBREW_CELLAR}
      EOS
    end
  end

  test do
    system bin/"nmap", "-p80,443", "google.com"
  end
end
