class Nextflow < Formula
  desc "Reproducible scientific workflows"
  homepage "https://nextflow.io"
  url "https://github.com/nextflow-io/nextflow/archive/refs/tags/v25.10.4.tar.gz"
  sha256 "23eb79f23dc96bfa52669bc5bb845cd0987ec103dc25831b323d1ade5614f23a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75b8e98abd71d583a5c5a6677b7f1e7f731efd0c71b3938ac8d7452d9a1dfdf5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd11f1daf4e8fa76c0e0141ff630af48bc9bc7bd87f9573aefbee0f7242def50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "465b89e3de403a466b1c3dc55ee1a4c5349761b0cf6a5ad2a0b04ada6603fc3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8fdebff6bf949ae913d3b51f8a208937dba5ef8445e3a03357b66ec0a4db711d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90ca508948b6aa7d3c28090baa59f89e0365301a4238342312cd4f666279972e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f7cef0e969ca6e44917cd79ae967f397018614abdfae03bc07e39ce3f0f38bc"
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
