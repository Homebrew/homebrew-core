class Liblbfgs < Formula
  desc "C library for limited-memory BFGS optimization algorithm"
  homepage "https://www.chokkan.org/software/liblbfgs"
  url "https://github.com/chokkan/liblbfgs/archive/refs/tags/v1.10.tar.gz"
  sha256 "95c1997e6c215c58738f5f723ca225d64c8070056081a23d636160ff2169bd2f"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "d88172caad8ef6e5a35ca17ed81ee20ecb8bfe0a245f9ea1b7b16e0c88bc3cb7"
    sha256 cellar: :any,                 arm64_sequoia:  "9d20979a75f869868f997ad0c9596646bb3ccc5683b54c192a923f5818096444"
    sha256 cellar: :any,                 arm64_sonoma:   "77b0dfdc9c988252874e28090eeafd90d74034214c5a46d2669da0f850a4e925"
    sha256 cellar: :any,                 arm64_ventura:  "06c8d7b71b75a24838acbd0a60a071d146b8befb750d18dd0197acc7a3f4552a"
    sha256 cellar: :any,                 arm64_monterey: "e65a09362f54852c0b5bbd9a38fc2df634bdd0cd1f151ad2497b287688edb334"
    sha256 cellar: :any,                 arm64_big_sur:  "77960d72a78a9bfae97e725b8bcf37b5105b5e3254ce319487e0a5b3a707db5f"
    sha256 cellar: :any,                 sonoma:         "56d3aece128cfb420a427eb7f6513e539a6e51b777d281c8c6fa6bf804693305"
    sha256 cellar: :any,                 ventura:        "1f48ca57c0b49cd4414d8a7462c7495951285c63d4d9490be95bd355e695a431"
    sha256 cellar: :any,                 monterey:       "7000437bee7f617b05b7f6f6a9adef00f8f8664f37fc34cc6758d461af136b89"
    sha256 cellar: :any,                 big_sur:        "3b6468ee0f05eae6289940247c51e1012e929a8a033e2227be767d17396f88a7"
    sha256 cellar: :any,                 catalina:       "668f1c5336818e566dd0cb2e4b1deb0eacdb38fd8c956b1b2e49929f18714104"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b45e6bbae731b52f94d92784f30120bf36bf7169df1d6956b5398473438d6f95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c462aa266b91b96ed0f85ce8a495cb29ed9c571943ffb0eb8b65f5bd7406d7cc"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
    pkgshare.install "sample/sample.c"
  end

  test do
    cp pkgshare/"sample.c", testpath/"sample.c"
    system ENV.cc, "sample.c", "-I#{include}", "-L#{lib}", "-llbfgs", "-o", "./test"
    output = shell_output("./test")

    assert_match "L-BFGS optimization terminated with status code = 0", output
    assert_match "fx = 0.000000, x[0] = 1.000000, x[1] = 1.000000", output
  end
end
