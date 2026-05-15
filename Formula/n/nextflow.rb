class Nextflow < Formula
  desc "Reproducible scientific workflows"
  homepage "https://nextflow.io"
  url "https://github.com/nextflow-io/nextflow/archive/refs/tags/v26.04.1.tar.gz"
  sha256 "c3dc720e3ff8377d8b8ff95d9afa4239922a86abe1da45b269c49ec7368dbc4b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd5b78bef096060b3f39948e71d1242b3e4c4800de18fe8c5bc6a2280ba4d9b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea1e59f2ffb195599aca043feb54942654c7f4de72148c041a082a1ba8604315"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5add0fdd7c47f5ea03556725af570a34a397f0b462baf5808efae32ac1b91119"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d38335d567bcf75a3600c9c8ffc103389f959510ad9213099ea171d07fc720f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b2fc26ab23da7d3bc8e200c5fa7833210095348d779290ab71e66e8aa03322d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89a8169b409dd53c33b59b48aeb23089fa6eb82c071a4ef01851e74f41bc34db"
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
    (testpath/"hello.nf").write <<~EOS
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
    EOS

    system bin/"nextflow", "run", "hello.nf"

    assert_path_exists testpath/"results/hello.txt"
    assert_match "Hello!", (testpath/"results/hello.txt").read
  end
end
