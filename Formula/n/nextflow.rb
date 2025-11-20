class Nextflow < Formula
  desc "Reproducible scientific workflows"
  homepage "https://nextflow.io"
  url "https://github.com/nextflow-io/nextflow/archive/refs/tags/v25.10.0.tar.gz"
  sha256 "124bb52f281159d2b60983a58d505bb8a85c2e1726f85338ea197e08268c7f5f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87eeaa6fb715b56bb62d7e930d2096d260780c1d7148b15368f44177cbea359a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fc4f3d1978f211b9a6e28f689b75a98fa97ff975a9569837b19a06d8e921b25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7ab5a73bfd8359baa33bb3153a1bc2ad270b5b14d84ea8c24f1d3057cdc90f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "72d88010882e4eec672c3c7ee4bd0c476a8e09b41535d7a948c853f6f01bc991"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76422087bc55bcf7fd6ce5275e0ff455b5ba42b1a67fd3a140029f680d4aafc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c42f136e27541fcda577c76e56f521ccf708a601b4768664af40ae93bb079988"
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
