class DatetimeFortran < Formula
  desc "Fortran time and date manipulation library"
  homepage "https://github.com/wavebitscientific/datetime-fortran"
  url "https://github.com/wavebitscientific/datetime-fortran/releases/download/v1.7.0/datetime-fortran-1.7.0.tar.gz"
  sha256 "cff4c1f53af87a9f8f31256a3e04176f887cc3e947a4540481ade4139baf0d6f"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "695983e52548982491c67fd9f018cf42e9d1a5b0de590d932a6af1dabbf51317"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3f396ad5136d8087e6de3dfdbf70616503a1b929fae3bf4cca376bc88d3eea23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a58282caee75e7ce6eab6efde945c00d6a025c34bb0c835462592e229d51924d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bcc7d71f13bb6e54b53bafe5755a5c44d8bf9af567347420206d32fadf2a08c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17b99bbbc87ea9bdc282aa0138a56d91922e19de55208ecb8110d2f5cb32d488"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a94f87cd83073ecb65477288b6e0cd0e4a82002f4625b2dd27fad436b2b8673"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d987d5e46bf84112aa565f409f0750523bfbaf7b46f2e6946fdb41c7a4840d2"
    sha256 cellar: :any_skip_relocation, ventura:        "f12bb3de09be467e5be1c6934110f5c5f9952bd9822c754995bae144610968d9"
    sha256 cellar: :any_skip_relocation, monterey:       "0307d4a29c988223ddd6fcfa2049fa86774bf68da91d6925492a19fe47aaec54"
    sha256 cellar: :any_skip_relocation, big_sur:        "a90fa3af5145c4f7f2a922071ea5edf3c8f2abeef78da13b85bcda8523239693"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c69feef25cb84ecf1e957bab83ebab3d802320c59b890a90a1b60778603c57a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5d30fcf0a1ad22b28261d2f0e848e02c4ac9705cb559c5a19ffa9e2db8c3356"
  end

  head do
    url "https://github.com/wavebitscientific/datetime-fortran.git", branch: "main"

    depends_on "autoconf"   => :build
    depends_on "automake"   => :build
    depends_on "pkgconf" => :build
  end

  depends_on "gcc" # for gfortran

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
    (pkgshare/"test").install "tests/datetime_tests.f90"
  end

  test do
    system "gfortran", "-I#{include}", pkgshare/"test/datetime_tests.f90",
                       "-L#{lib}", "-ldatetime", "-o", "test"
    system "./test"
  end
end
