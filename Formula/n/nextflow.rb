class Nextflow < Formula
  desc "Reproducible scientific workflows"
  homepage "https://nextflow.io"
  url "https://github.com/nextflow-io/nextflow/archive/refs/tags/v26.04.3.tar.gz"
  sha256 "4bebe394c419f089402291040d4f240a2cff98d91957fadc6d6667763d79ea28"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56e87c0f196c0d02c5a8bdc8ca77fa45ebc1d80e1692940043f77e4eaca86ed6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "912b418c7eb8bf19f4e0d91ec49b8f545d6034eec142da624919d775db8d4c3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86c34387cfeb89c3a930788f0e0ba5cc6fe96886cd769bf493af60932673cc31"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f480cf13b01efc176226c82b9e978ed0763e31b010420f8540f252db82c6839"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bdf8bc0a9a49974d9d3be64b80e336b6c1e5f4c340dbe0f6120e5790884083d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fccad61d57ca0ce82fadcce38b051fef70b169ae885d435580e3c9860dcb92a"
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
