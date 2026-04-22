class Omniorb < Formula
  desc "IOR and naming service utilities for omniORB"
  homepage "https://omniorb.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/omniorb/omniORB/omniORB-4.3.4/omniORB-4.3.4.tar.bz2"
  sha256 "79720d415d23cd8da99287a4ef4da0aa1bd34d3e4c7b1530715600adc5ed3dc3"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url :stable
    regex(%r{url=.*?/omniORB[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "69b171103aff52ec76b37157af9cafc619a8ab5f65daa0676ac03a39f94b3fcd"
    sha256 cellar: :any,                 arm64_sequoia: "be7ed7887d18f0c634f0a9a0fcf50e3baad81ac4dc19485a380ccef79b39c60f"
    sha256 cellar: :any,                 arm64_sonoma:  "b7e79d9bd6cf2c3146ad1aae8fda733fab5fcb6977c10b8bf1e1f82779fc4f0d"
    sha256 cellar: :any,                 sonoma:        "4dd41368f4fde967adde35d8839e3e20078e32b13e41baa1fd852c8e3afffe36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fb616f204dc7acf360397e4aeea7d145d6c5eb32c27f152de10c771a042ac2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a82a3a9f22891f7155ca75558b834b0465338da0c4a03875648428527b64dcd"
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"
  depends_on "python@3.14"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "bindings" do
    url "https://downloads.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-4.3.4/omniORBpy-4.3.4.tar.bz2"
    sha256 "a709c3c77b9c6b08616e1c9e12a5a9b9d5ccc1f2dcf6f647f205018d77f819a7"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "bindings resource needs to be updated" if version != resource("bindings").version

    # Help old config scripts identify arm64 linux
    build_arg = []
    build_arg << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm64?

    ENV["PYTHON"] = python3 = which("python3.14")
    xy = Language::Python.major_minor_version python3
    inreplace "configure",
              /am_cv_python_version=`.*`/,
              "am_cv_python_version='#{xy}'"
    args = build_arg + ["--with-openssl"]
    args << "--enable-cfnetwork" if OS.mac?

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"

    resource("bindings").stage do
      inreplace "configure",
                /am_cv_python_version=`.*`/,
                "am_cv_python_version='#{xy}'"
      system "./configure", *build_arg, *std_configure_args
      ENV.deparallelize # omnipy.cc:392:44: error: use of undeclared identifier 'OMNIORBPY_DIST_DATE'
      system "make", "install"
    end
  end

  test do
    system bin/"omniidl", "-h"
    system bin/"omniidl", "-bcxx", "-u"
    system bin/"omniidl", "-bpython", "-u"
  end
end
