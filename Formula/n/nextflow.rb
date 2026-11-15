class Nextflow < Formula
  desc "Reproducible scientific workflows"
  homepage "https://nextflow.io"
  url "https://github.com/nextflow-io/nextflow/archive/refs/tags/v26.10.6.tar.gz"
  sha256 "71f65630dd3d6f205724956ec8d86cfc34fa42ee6b82ffe56980b2488631cb17"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f7ef6d0f2afcbbda3062794373ea8f5b8282ca41d010012f3c7ca4c78da26ddb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "75a03c207097b0359d7bf7a57c0140157d6fcbbbe17a03af2094f1b40047f888"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "532938eba78f01525e51e19c774cc3fe30d1f5f1284a3233956c79535046ae4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c66263ed2c9f4724104c4e79f2d1d9a65696dea22c91f9e9efdce70eea72ce31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ada8dd9536d3e03b9397f7f717471b57bc94e0304bdb055bcdd2a05a0ca2238d"
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
