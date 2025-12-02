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

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "f5baa53cabbdcdba97c61a8734543b06ffecf1edfb6a072fffe33673b6adda14"
    sha256 cellar: :any,                 arm64_sequoia: "0b51ea7384a8623316882a7e4ca9fd5a67fd290fc2cea4f37e1b202b565a33cf"
    sha256 cellar: :any,                 arm64_sonoma:  "02643e311b7153fc874298fc931b1a685a2cacee774b094807ca907938d1d778"
    sha256 cellar: :any,                 sonoma:        "b3e66db5bd5d27ebb26eb4afad56169753c690f85606abcd28855f15eafbf5b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9dad60ccd17c70c50388e58642587f660497c819d964544cb59ef9a80f942133"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3383d6eb3b97d354416fa7257bf7beafbbaa14d671dc285e44cf6b2c0116356b"
  end

  depends_on "buildapp" => :build

  depends_on "freetds"
  depends_on "libpq"
  depends_on "openssl@3"
  depends_on "sbcl"
  depends_on "zstd"

  on_linux do
    # Patchelf will corrupt the SBCL core which is appended to binary.
    on_arm do
      pour_bottle? only_if: :default_prefix
    end
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    system "make"
    bin.install "bin/pgloader"

    # Work around patchelf corrupting the SBCL core which is appended to binary
    # TODO: Find a better way to handle this in brew, either automatically or via DSL
    if OS.linux? && build.bottle?
      cp bin/"pgloader", prefix
      Utils::Gzip.compress(prefix/"pgloader")
    end
  end

  def post_install
    if (prefix/"pgloader.gz").exist?
      system "gunzip", prefix/"pgloader.gz"
      bin.install prefix/"pgloader"
      (bin/"pgloader").chmod 0755
    end
  end

  test do
    output = shell_output("#{bin}/pgloader --summary 2>&1", 2)
    assert_match "pgloader [ option ... ] SOURCE TARGET", output

    assert_match version.to_s, shell_output("#{bin}/pgloader --version")
  end
end
