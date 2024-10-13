class Pgloader < Formula
  desc "Data loading tool for PostgreSQL"
  homepage "https://github.com/dimitri/pgloader"
  url "https://github.com/dimitri/pgloader/releases/download/v3.6.9/pgloader-bundle-3.6.9.tgz"
  sha256 "a5d09c466a099eb7d59e485b4f45aa2eb45b0ad38499180646c5cafb7b81c9e0"
  license "PostgreSQL"
  revision 1
  head "https://github.com/dimitri/pgloader.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "cb7f5d7b24d71a33f540c1deac860c14ac23a722ea8d090dcee236d323fb91c7"
    sha256 cellar: :any,                 arm64_sonoma:   "e9e988b590421ba3ebbf60331db3cb54d713d3629e53905218cdfe677d83190b"
    sha256 cellar: :any,                 arm64_ventura:  "66c38d5680137c97900e8bc0345212df6ef9c246688263d27a1612f0c68362a3"
    sha256 cellar: :any,                 arm64_monterey: "368d8f4b75362e444098030d8a7de45e09c495d501037a679670a1349bc366a8"
    sha256 cellar: :any,                 sonoma:         "4b2bb7c9ae9bd104768e44181fcb9536928d5d37a20a39b66dd29d3446eecef8"
    sha256 cellar: :any,                 ventura:        "8abc681975f40539f48f3444ffee0d6028080ee7dfbff23a69d2d1ad283079cd"
    sha256 cellar: :any,                 monterey:       "52cdba8d7bf8f2a836eeba8b6e2eae1521d95a31a0203edb0f5ae9b1a05ae394"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3066fd9fdb9548c8e1d3f6bb445017b0da557e00247d72bb8c2cafc4aed41d3"
  end

  depends_on "buildapp" => :build

  depends_on "freetds"
  depends_on "libpq"
  depends_on "openssl@3"
  depends_on "sbcl"
  depends_on "zstd"

  def install
    system "make"
    bin.install "bin/pgloader"
  end

  test do
    # Fails in Linux CI with "Can't find sbcl.core"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    output = shell_output("#{bin}/pgloader --summary 2>&1", 2)
    assert_match "pgloader [ option ... ] SOURCE TARGET", output

    assert_match version.to_s, shell_output("#{bin}/pgloader --version")
  end
end
