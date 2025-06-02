class Jq < Formula
  desc "Lightweight and flexible command-line JSON processor"
  homepage "https://jqlang.github.io/jq/"
  url "https://github.com/jqlang/jq/releases/download/jq-1.8.0/jq-1.8.0.tar.gz"
  sha256 "91811577f91d9a6195ff50c2bffec9b72c8429dc05ec3ea022fd95c06d2b319c"
  license "MIT"

  livecheck do
    url :stable
    regex(/^(?:jq[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5911dafda561f792305dbc34b1f2ca5265bede9d7e60c655d9390511b560df4e"
    sha256 cellar: :any,                 arm64_sonoma:  "de8dbc03158683f974e8ef52f886abe1d6d6250dba92e2b0e5c7758eb1a5168c"
    sha256 cellar: :any,                 arm64_ventura: "4a5c7fa291902388f6e869f6d656619be87a1af597b448e7280813075ed16c2e"
    sha256 cellar: :any,                 sonoma:        "856817ef0376db702b90fb543180abbf519914f83b0c968f5e668b902cca3e28"
    sha256 cellar: :any,                 ventura:       "b25424ffc93b27bce860c31eea8ab6174e6e68efa9ae12a1eb985eefdb08e46d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1762be8892ea341cf8062fcdb7587ca9366bfb16e645a5d076d6149ba95dfe4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "589b86f4e458ce4c6236e18e0a938474f61480cf7034418313c476410a2cc942"
  end

  head do
    url "https://github.com/jqlang/jq.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "oniguruma"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--disable-maintainer-mode"
    system "make", "install"
  end

  test do
    assert_equal "2\n", pipe_output("#{bin}/jq .bar", '{"foo":1, "bar":2}')
  end
end
