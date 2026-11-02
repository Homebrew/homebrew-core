class Nextflow < Formula
  desc "Reproducible scientific workflows"
  homepage "https://nextflow.io"
  url "https://github.com/nextflow-io/nextflow/archive/refs/tags/v26.10.5.tar.gz"
  sha256 "1789227a370b24821054dbd87dd69b32912d9fa6daf8571d1dccf2d236358525"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f20dd583dd59188e394fa5a72764cd9c07765d7388ab22acea6b56eeb7dcec70"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "610dd9f8c28a1981f043de540eacf5bdc3a6cc6d84dd07ed2cbdb779fe3182da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0f262ceb252031c91e6014dfbac0bb53ab05f992647d95ca4a731ca61fda7721"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "48edd01ce639ed9213590999f3afa245435ffb8db36089bd297ed7a138843854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "68222ec9500e59b4a63046ac0aafd66444105f2a1cc8b18e77c8f365e7977882"
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
