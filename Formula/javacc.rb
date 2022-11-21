class Javacc < Formula
  desc "Parser generator for use with Java applications"
  homepage "https://javacc.org/"
  url "https://github.com/javacc/javacc/archive/javacc-7.0.12.tar.gz"
  sha256 "1b38fa8c9e8348fe72b46fbdbaed2f05783a796a7417e3d22af18df5833b8850"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/javacc[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7466143225c24a1036a193bf7a0762e110c16606993fc427954959318ff35cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39bb12ada55f290fb1c1a78f4d213043085473d98fb807acdd689799da5ded6a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a83efed645f130bab65f202a0b33b75671988767b9e163d5cb124fe6e6b6743"
    sha256 cellar: :any_skip_relocation, ventura:        "b006fcc7e7738ad3596c8fd565ed19ba36eaae5efcac77ca1d1e1d8121a07f6c"
    sha256 cellar: :any_skip_relocation, monterey:       "a9b7638acf530cb10611b394486b16a8f9c411b529e8c954428e84f95aa6cf85"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a7f5daba6e577455d592eeb3f5da018f6a7479aa60be2872297fe809b19410d"
    sha256 cellar: :any_skip_relocation, catalina:       "5ebc37d85cd1cac3a449c06d377e62d40e989e1debb3b9c3dd10b0eada6b8ce5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f040860fb051d65ce29f77810fa6babc68b6a067f4bb854995cd73f1f50ba4d7"
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
