class Nextflow < Formula
  desc "Reproducible scientific workflows"
  homepage "https://nextflow.io"
  url "https://github.com/nextflow-io/nextflow/archive/refs/tags/v26.04.4.tar.gz"
  sha256 "9c191514b7edc5285d1bd029e913da775bde61ad57586aba062ca85d29ff991b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c959d30dd55f435d157d71e11eaeb039c0220fb97fc44300583169178201320"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebed4ace175fb9eac2d885dd400a813fe3c93499138676a50650c0f8f995a09e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2a42c43f85c2296df3010c4ac2325b390c774f1153d254eb17590ad1bc1d0b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "577a05bbfb2cad36071a3c6c71ed00bab23e83cfa2c50e090d3eef528405721c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "100ee07c925bb4f3ca52867fa62ab198629e32a4edccad0ab28605052f869f6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39ba2584deee6bd146c534ebef99f14ec0d363be630acb38f84f38ee6e7d7157"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    ENV["BUILD_PACK"] = "1"

    system "gradle", "pack", "--no-daemon", "-x", "test"
    libexec.install "build/releases/nextflow-#{version}-dist" => "nextflow"

    (bin/"nextflow").write_env_script libexec/"nextflow", Language::Java.overridable_java_home_env
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
