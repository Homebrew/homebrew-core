class Pgloader < Formula
  desc "Data loading tool for PostgreSQL"
  homepage "https://github.com/dimitri/pgloader"
  license "PostgreSQL"
  revision 1

  stable do
    # Using git checkout as Makefile runs `git archive` to create bundle
    url "https://github.com/dimitri/pgloader.git",
        tag:      "v3.6.10",
        revision: "af8c3c147297654967a0744052ab2eb8682b1466"

    depends_on "sbcl" => :build
    depends_on "freetds" => :no_linkage
    depends_on "openssl@4" => :no_linkage
    depends_on "zstd"

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
    sha256 cellar: :any, arm64_golden_gate: "e8fe4fee4c412f044630dd7895ea2ccdfaea858329311f5ae47422aa113783a1"
    sha256 cellar: :any, arm64_tahoe:       "f165cb8d195b73c68033bbc9f88807c694f86868928e544eb3fa0efd6887831d"
    sha256 cellar: :any, arm64_sequoia:     "6d197ce7cb750d3b7fe7df0d687ab23915f0b5c52474e2169c2de306d9c28cdc"
    sha256 cellar: :any, arm64_linux:       "9c17f985edac3620ec52b5407be64fe0547bb34712ef157e910c3e660ce00a04"
    sha256 cellar: :any, x86_64_linux:      "7cdd5f783ddcad605de8a46615c1d5bcfd1bae4c287e0cf4745bf4b37c605199"
  end

  head do
    url "https://github.com/dimitri/pgloader.git", branch: "main"

    depends_on "clojure" => :build
    depends_on "openjdk"
  end

  on_linux do
    # Patchelf will corrupt the SBCL core which is appended to binary.
    # TODO: Remove in 4.0
    pour_bottle? only_if: :default_prefix
  end

  def install
    if build.stable?
      bundlename = "pgloader-bundle"
      # Improve reproducibility by avoiding master branch and git clones usage
      inreplace "Makefile", /(git archive .*) master /, "\\1 v#{version} "
      resources.each do |r|
        r.stage("build/bundle/#{bundlename}/local-projects/#{r.name}")
      end

      # Creating bundle to use fixed date for reproducibly fetching dependencies. Increasing date to get
      # https://github.com/melisgl/named-readtables/commit/6eea56674442b884a4fee6ede4c8aad63541aa5b
      system "make", "build/#{bundlename}.tgz", "BUNDLENAME=#{bundlename}", "BUNDLEDIST=2026-01-01"

      bin.mkpath
      system "tar", "-xf", "build/#{bundlename}.tgz"
      system "make", "-C", bundlename, "PGLOADER=#{bin}/pgloader"

      # Work around patchelf corrupting the SBCL core which is appended to binary
      if OS.linux? && build.bottle?
        cp bin/"pgloader", prefix
        Utils::Gzip.compress(prefix/"pgloader")
      end
    else
      cd "clojure" do
        system "clojure", "-T:build", "uber"
        libexec.install Dir["target/pgloader*.jar"]
        bin.write_jar_script libexec/"pgloader.jar", "pgloader"
      end
    end
  end

  # TODO: Remove in 4.0
  post_install_steps do
    install_gzipped_executable "pgloader.gz", "bin/pgloader"
  end

  test do
    output = shell_output("#{bin}/pgloader --summary 2>&1", 2)
    assert_match "pgloader [ option ... ] SOURCE TARGET", output

    assert_match version.to_s, shell_output("#{bin}/pgloader --version")
  end
end
