class Ledger < Formula
  desc "Command-line, double-entry accounting tool"
  homepage "https://ledger-cli.org/"
  license "BSD-3-Clause"
  revision 10
  head "https://github.com/ledger/ledger.git", branch: "master"

  stable do
    url "https://github.com/ledger/ledger/archive/refs/tags/v3.3.2.tar.gz"
    sha256 "555296ee1e870ff04e2356676977dcf55ebab5ad79126667bc56464cb1142035"

    # Support building with mandoc
    # Remove with v3.4.x
    patch do
      url "https://github.com/ledger/ledger/commit/f40cee6c3af4c9cec05adf520fc7077a45060434.patch?full_index=1"
      sha256 "d5be89dbadff7e564a750c10cdb04b83e875452071a2115dd70aae6e7a8ee76c"
    end
    patch do
      url "https://github.com/ledger/ledger/commit/14b90d8d952b40e0a474223e7f74a1e6505d5450.patch?full_index=1"
      sha256 "d250557e385163e3ad3002117ebe985af040d915aab49ae1ea342db82398aeda"
    end

    # Backport fix to build with `boost` 1.85.0
    patch do
      url "https://github.com/ledger/ledger/commit/46207852174feb5c76c7ab894bc13b4f388bf501.patch?full_index=1"
      sha256 "8aaf8daf4748f359946c64488c96345f4a4bdf928f6ec7a1003610174428599f"
    end

    # Backport fixes to build with `boost` 1.86.0
    # Ref: https://github.com/ledger/ledger/pull/2381
    patch do
      url "https://github.com/ledger/ledger/commit/ad93c185644cfcb14fe4a673e74a0cb5c954a4b4.patch?full_index=1"
      sha256 "3d2db6b116cd7e8a1051ac7f92853f72c145ff0487f2f4e12e650ee7ec9e67b0"
    end
    patch do
      url "https://github.com/ledger/ledger/commit/4f4cc1688a8e8a7c03f18603cc5a4159d9c89ca3.patch?full_index=1"
      sha256 "938d62974ee507b851239b6525c98c8cb1c81e24e8ae2939d4675d97a8ec8f67"
    end
    patch do
      url "https://github.com/ledger/ledger/commit/5320c9f719a309ddacdbe77181cabeb351949013.patch?full_index=1"
      sha256 "9794113b28eabdcfc8b900eafc8dc2c0698409c0b3d856083ed5e38818289ba1"
    end

    # CMakeLists.txt update for use of `CMAKE_CXX_STANDARD`
    # It is set to 17 but we have to use 14 for compatibility issue with other sources
    patch do
      url "https://github.com/ledger/ledger/commit/8e64a1cf7009bbe7b89dc8bcb7abd00e39815b0b.patch?full_index=1"
      sha256 "116cc2c4d716df516c2ad89241bc9fed6943013aacdfcd03757745202416bc72"
    end
    patch do
      url "https://github.com/ledger/ledger/commit/19b0553dfbcd65c3c601b89e7020bff8013cb461.patch?full_index=1"
      sha256 "9f70e40ca3eec216959a02e7f4ea626d265957443c2ec5d5219977ed2e525332"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "54988694adbadceb13c13156af0bed21ad9f15b3fa120ccb22894514cf9a5506"
    sha256 cellar: :any,                 arm64_sonoma:  "77d3511a4314bfa674ed8228d630c38cbee2d0232d241d07fbba7fdbd4c7cd84"
    sha256 cellar: :any,                 arm64_ventura: "68fa609eba85586c556d62db46585bf5c5447babffbc597e931cc8d788d4992a"
    sha256 cellar: :any,                 sonoma:        "7eb65f0472a64ac1f08c97fee3af4024cd403107802b63d2a1af457eda0de180"
    sha256 cellar: :any,                 ventura:       "a209aef25a18b73852e27582ecbca1af836ac1b70d8734751a3fdc804451272f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd91a4adea0704c7a588299d9a1dc42aa8dba18c58327f9f1d0aa745330d780a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed37e34cd74761ab49724546a6a83a5f59eb316ab2d76f03ab3ba95728e0b726"
  end

  depends_on "cmake" => :build
  depends_on "texinfo" => :build # for makeinfo
  depends_on "boost"
  depends_on "gmp"
  depends_on "gpgme"
  depends_on "gpgmepp"
  depends_on "mpfr"
  depends_on "python@3.13"

  uses_from_macos "mandoc" => :build
  uses_from_macos "libedit"

  on_macos do
    depends_on "libassuan"
  end

  def install
    if build.stable?
      inreplace "CMakeLists.txt" do |s|
        # Workaround until next release as commit doesn't apply
        # https://github.com/ledger/ledger/commit/956d8ea37247b34a5300c9d55abc7c75324fff33
        s.gsub! "cmake_minimum_required(VERSION 3.0)", "cmake_minimum_required(VERSION 3.5)"

        # Workaround to build with Boost 1.89.0 until release with fix
        # PR for HEAD: https://github.com/ledger/ledger/pull/2430
        s.gsub! "REQUIRED date_time filesystem system ", "REQUIRED date_time filesystem "
      end
    end

    ENV.prepend_path "PATH", Formula["python@3.13"].opt_libexec/"bin"

    args = %W[
      --jobs=#{ENV.make_jobs}
      --output=build
      --prefix=#{prefix}
      --boost=#{Formula["boost"].opt_prefix}
      --
      -DBUILD_DOCS=1
      -DBUILD_WEB_DOCS=1
      -DBoost_NO_BOOST_CMAKE=ON
      -DPython_FIND_VERSION_MAJOR=3
      -DUSE_GPGME=1
      -DCMAKE_CXX_STANDARD=14
    ] + std_cmake_args

    system "./acprep", "opt", "make", *args
    system "./acprep", "opt", "make", "doc", *args
    system "./acprep", "opt", "make", "install", *args

    (pkgshare/"examples").install Dir["test/input/*.dat"]
    pkgshare.install "contrib"
    elisp.install Dir["lisp/*.el", "lisp/*.elc"]
    bash_completion.install pkgshare/"contrib/ledger-completion.bash" => "ledger"
  end

  test do
    balance = testpath/"output"
    system bin/"ledger",
      "--args-only",
      "--file", pkgshare/"examples/sample.dat",
      "--output", balance,
      "balance", "--collapse", "equity"
    assert_equal "          $-2,500.00  Equity", balance.read.chomp
  end
end
