class Nextflow < Formula
  desc "Reproducible scientific workflows"
  homepage "https://nextflow.io"
  url "https://github.com/nextflow-io/nextflow/archive/refs/tags/v25.10.2.tar.gz"
  sha256 "134ed5ec8bca7d1c8aca7d075cec681baaa2c06340883b7f00e3d7a7cb4b19e0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dff64494b8e20fd4531562639a67349a4091a02c5ba0920bebb4d27d55f8ff3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f67850cb40900e134d84ecab944fa72e66d313f0c823f4135d20b06a003104a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ef0424fdb6114a2ea83d97b769e7e6d9748f0291cbf58083f95dba6e8f42d00"
    sha256 cellar: :any_skip_relocation, sonoma:        "b105e04db0617b4b09b08eb8298ba9037bccdcb9a2eb6ae9b0d45c91423a795d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0fa85b97b3205ef5d154b87eaf8a6e22edc4a9f96687ec6cfa9f2fc1679181b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b12940f81e88872f4d7829ca74a8161a2df713f7d45c7d64f1e6814a3d8eebe"
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
