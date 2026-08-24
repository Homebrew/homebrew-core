class Delly < Formula
  desc "Structural variant discovery by paired-end and split-read analysis"
  homepage "https://github.com/dellytools/delly"
  url "https://github.com/dellytools/delly/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "fab93a5d7cfbf7b069c2d082f68dfe968799f0612b28a22aada9eda50b87595e"
  license "BSD-3-Clause"
  head "https://github.com/dellytools/delly.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "1457782beb0aae5db020fd5878adfc05199df2314ac8f32bbc5a7fb68a5eac72"
    sha256 cellar: :any, arm64_sequoia: "4b6b3d698129a34927700e21527c47cb68ba76edb1fe7229be8b2e207fe6e9ae"
    sha256 cellar: :any, arm64_sonoma:  "b0253b4ea8c4cfe16fbad2a66a06aa5642851a5e666dc650fcb3181c51530304"
    sha256 cellar: :any, sonoma:        "ef84a6f6df952de40b6ae9f9d94c5ebebead55c9c4e6d503022526f64ac503df"
    sha256 cellar: :any, arm64_linux:   "e3c60b96864c43f9a363566d7c26d0492257def838e202bd90f08ea0f21bae2f"
    sha256 cellar: :any, x86_64_linux:  "6a5039f306ff0635f8e475ef6e44f5f35d336462c976a13eeea98729683ef081"
  end

  depends_on "boost"
  depends_on "htslib"
  depends_on "xz"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "make", "src/delly",
           "HTSLIBINCDIR=#{formula_opt_include("htslib")}",
           "HTSLIBLIBDIR=#{formula_opt_lib("htslib")}",
           "BOOSTINCDIR=#{formula_opt_include("boost")}",
           "BOOSTLIBDIR=#{formula_opt_lib("boost")}"
    bin.install "src/delly"
    pkgshare.install %w[example R scripts]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/delly --version 2>&1")
    system bin/"delly", "lr", "-g", pkgshare/"example/ref.fa", "-o", testpath/"lr.bcf", pkgshare/"example/lr.bam"
    assert_path_exists testpath/"lr.bcf"
  end
end
