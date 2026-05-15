class Pgloader < Formula
  desc "Data loading tool for PostgreSQL"
  homepage "https://github.com/dimitri/pgloader"
  license "PostgreSQL"
  head "https://github.com/dimitri/pgloader.git", branch: "master"

  stable do
    # Using git checkout as Makefile runs `git archive` to create bundle
    url "https://github.com/dimitri/pgloader.git",
        tag:      "v3.6.10",
        revision: "af8c3c147297654967a0744052ab2eb8682b1466"

    # Resources to avoid `git clone`-ing them in Makefile
    resource "qmynd" do
      url "https://github.com/qitab/qmynd/archive/42664f5fd15a2f308c958c1062edebec30125308.tar.gz"
      sha256 "f81c0511be76678649da1e7df2d0bf0c370ed190c11405b914378b55958ab97f"
    end

    resource "cl-ixf" do
      url "https://github.com/dimitri/cl-ixf/archive/ed26f87e4127e4a9e3aac4ff1e60d1f39cca5183.tar.gz"
      sha256 "22e3ad4595ff845bd610f472267a14070b3297058c597d753ac257c930094e10"
    end

    resource "cl-db3" do
      url "https://github.com/dimitri/cl-db3/archive/38e5ad35f025769fb7f8dcdc6e56df3e8efd8e6d.tar.gz"
      sha256 "6b7aeaa632799eb7b9ac474fbd196f4623f1093b957e6517c34c0d891cd2a21c"
    end

    resource "cl-csv" do
      url "https://github.com/AccelerationNet/cl-csv/archive/2d64d4183bfc91824068cd4cf3414238d3c00fe5.tar.gz"
      sha256 "c018cf1143a5542a6d263b23318628a17645c60b6c2bd1c6263907bcdeae9d55"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "12b8c22a69da1b380adc072b1f8ea9b9d2bdc69d03530a566251e163c7cfbe2b"
    sha256 cellar: :any,                 arm64_sequoia: "65977622649cc618a60bd5acaaedcce4ea0b5de39ef9a0ee3a77a5ba0819ffad"
    sha256 cellar: :any,                 arm64_sonoma:  "69167a059b6cf21e05fba0680ca9e0184dc269b556940ce0e304d1bd731c30ef"
    sha256 cellar: :any,                 sonoma:        "826b9b6529e101637416205667f78a0d0830f6f54c50b0b21f3ed8ef0d750758"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5640cc4d253febe88e8531a1767f7f3e3be20521192def77bac8bbeb1b10225"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f23ab10e44dba2d37a2581cf3ded0f0cfceb731e49af0f4565c98d60278a8a7"
  end

  depends_on "buildapp" => :build
  depends_on "sbcl" => :build

  depends_on "freetds" => :no_linkage
  depends_on "openssl@3" => :no_linkage
  depends_on "zstd"

  on_linux do
    # Patchelf will corrupt the SBCL core which is appended to binary.
    pour_bottle? only_if: :default_prefix
  end

  def install
    bundlename = "pgloader-bundle"
    if build.stable?
      # Improve reproducibility by avoiding master branch and git clones usage
      inreplace "Makefile", /(git archive .*) master /, "\\1 v#{version} "
      resources.each do |r|
        r.stage("build/bundle/#{bundlename}/local-projects/#{r.name}")
      end
    end

    # Creating bundle to use fixed date for reproducibly fetching dependencies. Increasing date to get
    # https://github.com/melisgl/named-readtables/commit/6eea56674442b884a4fee6ede4c8aad63541aa5b
    system "make", "build/#{bundlename}.tgz", "BUNDLENAME=#{bundlename}", "BUNDLEDIST=2026-01-01"

    bin.mkpath
    system "tar", "-xf", "build/#{bundlename}.tgz"
    system "make", "-C", bundlename, "BUILDAPP=#{Formula["buildapp"].bin}/buildapp", "PGLOADER=#{bin}/pgloader"

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
