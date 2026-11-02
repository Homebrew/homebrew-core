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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "266df921812c29d86f70e7d621fafd673ab22e8318b2c53747867808094687fa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "89a0890a56f24ea7f5ebb825b439f4b06bbdf0f8a70f0d645aaa5a55df0666c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2427b95548743b74bc56e32fceeb244e5475ff7ee84853c4e4edd3b38a4fcc24"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "97888f229846b5b24795bc9a748a9b4296ba48dc56fc99c88c8d092ab793b82c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c9b3a5a7577530eecf956ab82577db3d1ee33338321bc800255f0fd197fd2c97"
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
