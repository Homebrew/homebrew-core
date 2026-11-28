class Nextflow < Formula
  desc "Reproducible scientific workflows"
  homepage "https://nextflow.io"
  url "https://github.com/nextflow-io/nextflow/archive/refs/tags/v26.10.7.tar.gz"
  sha256 "2c81e696ed514642d6064ca38e1bb357829844e65db615faab1b07fda710f72b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "f8c2f0af2eddc4cc25fcd807e60d02e0cb9ad684df8e7a9572a5059ded182356"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9fd0b4c1dfc939d18d2fc84bd1796e44bf4998d4c6a56bfea62a8710889899fb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6ce9e9f45ae5b495e18f1bab0f9e4aa565031f74bec313fe50636eb854fbe698"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7b15871f801e0a7c3a39825e8840aa3337e3c4ad20f3a770baef02073b3225f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "db42454c840ea47fc68b03d95a2257b1076b7edce5a5c66c8c08fb5fb197761b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "032d6b3fadeefa3cd7cbc5add19b028bdab04c70f646d73dbd70251cba7615af"
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
