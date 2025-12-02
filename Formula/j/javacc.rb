class Javacc < Formula
  desc "Parser generator for use with Java applications"
  homepage "https://javacc.github.io/javacc/"
  url "https://github.com/javacc/javacc/archive/refs/tags/javacc-7.0.13.tar.gz"
  sha256 "d1bfebb4ca9261c5c3b16b00280b3278a41b193ca8503f2987f72de453bf99c6"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/javacc[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "2736d09dc1c90d1e95a14c99d8e1682120930718d32d8bede69b16e279a7508f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "9095c2d3b973f05a81fc336594a9adcab73f8a65634827167fad98f831719fff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f625a9b59d0fd505b1d69243c0147c292e4cd354550df5b352bcae140f7a2cbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "afb3bbdbbd9c451870e427fe76fedb3e4b4ae7016656281f55df63c3529590ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "daa582720875aecf351ec74ada244f93398fa25baf84eae2ef97c42c55476978"
    sha256 cellar: :any_skip_relocation, sonoma:         "b84312451176ab1a2df3d822798ca872ad17e94463cfa36711a5e2cfc4ff906b"
    sha256 cellar: :any_skip_relocation, ventura:        "ecd5ae75666cee39459c65063a32d4c24a27be79ae2125b12fa3ad5042bcb0d3"
    sha256 cellar: :any_skip_relocation, monterey:       "d4c07d3a5e68b54df0a7de796394bb9d765d9d863249f51e81a1921a38ca89cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "546e4c009d4fda3ed41b4a229d77059fb613c9558e158a037ddf47f7d6488c49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cfcf0b2f8d787fe06ac54aea4134722f7a4222f17b5402238a37177a0d73cc8"
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
    assert_path_exists output_file_stem.sub_ext(".java")

    system bin/"jjtree", src_file
    assert_path_exists output_file_stem.sub_ext(".jj.jj")

    system bin/"jjdoc", src_file
    assert_path_exists output_file_stem.sub_ext(".html")
  end
end
