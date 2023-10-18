class Javacc < Formula
  desc "Parser generator for use with Java applications"
  homepage "https://javacc.github.io/javacc/"
  url "https://github.com/javacc/javacc/archive/refs/tags/javacc-7.0.12.tar.gz"
  sha256 "bc007d0afa558778421656d48fc6a50c0899cd03e98362bb309c5b5b0eebc0d8"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/javacc[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e389b7d8c52452baf20f274fc0fe69d1e81e1bb429f31a24b363f71e2989a5e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96d07fbe2fbd9654a855f797c80c103fa172fddac617bc80e9e3e7129d4c128b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39a6299488da65b55988b26892e9f92ff478f998d23b6ba330e989f43a458946"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d664966eabcf84e469bea9750318fa01cef4c90493c4d2aa63c4c374c0e2f906"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe2ff8799d24cbcf7a30ce423fe1c9197bd4d6ec8b9c0882160033e322a738c5"
    sha256 cellar: :any_skip_relocation, ventura:        "ee01609b156af2e5bfff30bef4e46e8bc792e127c9b11cfe4af83483fffae792"
    sha256 cellar: :any_skip_relocation, monterey:       "936c4ab601e2e4275d3ec7d12ae23ea4fa531ed869af73432fd5b851d97334f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "9841265e02bc93d2a445148c06c3863f555cdefc0014111826b37ad4078f778d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b649624ca37c000e69273942af4f6c7368e10b51313889ac7ccbc1bdf301c0e"
  end

  depends_on "ant" => :build
  depends_on "openjdk"

  def install
    system "ant"
    libexec.install "target/javacc.jar"
    doc.install Dir["www/doc/*"]
    (share/"examples").install Dir["examples/*"]
    %w[javacc jjdoc jjtree].each do |script|
      (bin/script).write <<~SH
        #!/bin/bash
        export JAVA_HOME="${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
        exec "${JAVA_HOME}/bin/java" -classpath '#{libexec}/javacc.jar' #{script} "$@"
      SH
    end
  end

  test do
    src_file = share/"examples/SimpleExamples/Simple1.jj"

    output_file_stem = testpath/"Simple1"

    system bin/"javacc", src_file
    assert_predicate output_file_stem.sub_ext(".java"), :exist?

    system bin/"jjtree", src_file
    assert_predicate output_file_stem.sub_ext(".jj.jj"), :exist?

    system bin/"jjdoc", src_file
    assert_predicate output_file_stem.sub_ext(".html"), :exist?
  end
end
