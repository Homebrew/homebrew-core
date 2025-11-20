class Ftnchek < Formula
  desc "Fortran 77 program checker"
  homepage "https://www.dsm.fordham.edu/~ftnchek/"
  url "https://www.dsm.fordham.edu/~ftnchek/download/ftnchek-3.3.1.tar.gz"
  sha256 "d92212dc0316e4ae711f7480d59e16095c75e19aff6e0095db2209e7d31702d4"
  license "MIT"

  livecheck do
    url "https://www.dsm.fordham.edu/~ftnchek/ftp-index.html"
    regex(/href=.*?ftnchek[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "51bc89f67465eed6818e10244d47118c0710024a7d27223df320dce824035774"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b24d6d02b408a6348e92e426db421e6026f8fe8d7a0b6bc3b7ed11928ed3b1bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d616372988e0f0ffee9a0c7353615c8a2da497963a9e5705624699c06ea53600"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4eeca07e31edb1263e84863a38235058aecf081441f3cdae761cf556a634551f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d03c3735c56846ed42d9011ca800162519134c8965724ebc1e7862412bb3a17e"
    sha256 cellar: :any_skip_relocation, sonoma:         "f8079667f5a436173c2d7c7bb80551edad62853f0a2ee50d09cb6c3144072ade"
    sha256 cellar: :any_skip_relocation, ventura:        "87decd2c40db4d011c535284a764010635d20a9d788f11864539e2de3d4a39f4"
    sha256 cellar: :any_skip_relocation, monterey:       "7441b8a93f776b65a216b1f897527d002c070cddbdda7b28cdd3fe57c931cd76"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "cef69e1ad1770f524bc1b9ad957c69c5c2384a488f5d12f239b604ab50bb4cbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2183ef638b6941d2ae9916e3f7047f5a3599d4c54df8576e722874b7b8240fc"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  on_system :linux, macos: :ventura_or_newer do
    depends_on "groff" => :build
  end

  def install
    # Fix outdated host platform detection (use x86_64 and aarch64 instead
    # of i686 and arm, respectively)
    system "autoreconf", "--force", "--install", "--verbose"

    args = []

    # When building using brewed soelim (part of groff), the configure
    # script does not properly detect the path to soelim, so set it explicitly.
    args << "SOELIM=#{Formula["groff"].opt_bin}/soelim" if OS.linux? || (OS.mac? && MacOS.version >= :ventura)

    # Exclude unrecognized options
    args += std_configure_args.reject { |s| s["--disable-debug"] || s["--disable-dependency-tracking"] }

    system "./configure", *args
    system "make", "install"
  end

  test do
    # In fixed format Fortran 77, all lines of code starts 7th (or further)
    # column. The first 6 columns are reserved for labels, continuation
    # chars, etc.
    indent = " " * 6
    (testpath/"hello.f77").write <<~EOS
      #{indent}PROGRAM HELLOW
      #{indent}WRITE(UNIT=*, FMT=*) 'Hello World'
      #{indent}END
    EOS

    (testpath/"empty.f77").write ""

    assert_match "0 syntax errors detected in file hello.f77",
                 shell_output("#{bin}/ftnchek hello.f77")
    assert_match "No main program found",
                 shell_output("#{bin}/ftnchek empty.f77")
  end
end
