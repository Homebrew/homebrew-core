class Nextflow < Formula
  desc "Reproducible scientific workflows"
  homepage "https://nextflow.io"
  url "https://github.com/nextflow-io/nextflow/archive/refs/tags/v26.04.6.tar.gz"
  sha256 "485c4413948ddffce2bff02d8df63f6d5bbd88f7fd9c1a63d3a65a3cc8301b19"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "84fc63c3791a832c7752884ab1b51bd3783ef012716b6a3626a737906ef3e242"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ea4a1073fdfa91b84488be40d038bce7f6a3edbc8f59bbc6df1f9974b8bff643"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d0910dd4ce68028a767f774b333dfc87e99f3e11e5d1ab5aa9d96588b9c110bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2e3e44be5f2c8f938786a13e2d8d2e0aea60f7721d01016acb1d60b645f9b973"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b616e17dffdaf0b5f8b3d30244985f1a9617481102892d25b595044d8869fb50"
  end

  depends_on "gradle" => :build
  # TODO: Switch back to `openjdk` once Nextflow supports JDK 27: 26.04.6 documents
  # "Java 17 (or later, up to 26)" and fails with "Unsupported class file major version 71".
  # https://www.nextflow.io/docs/latest/install.html#requirements
  depends_on "openjdk@25"

  def install
    ENV["BUILD_PACK"] = "1"

    system "gradle", "pack", "--no-daemon", "-x", "test"
    libexec.install "build/releases/nextflow-#{version}-dist" => "nextflow"

    (bin/"nextflow").write_env_script libexec/"nextflow", Language::Java.overridable_java_home_env("25")
  end

  test do
    (testpath/"hello.nf").write <<~NF
      process hello {
        publishDir "results", mode: "copy"

        output:
        path "hello.txt"

        script:
        """
        echo 'Hello!' > hello.txt
        """
      }
      workflow {
        hello()
      }
    NF

    system bin/"nextflow", "run", "hello.nf"

    assert_path_exists testpath/"results/hello.txt"
    assert_match "Hello!", (testpath/"results/hello.txt").read
  end
end
