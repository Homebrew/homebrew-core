class Nextflow < Formula
  desc "Reproducible scientific workflows"
  homepage "https://nextflow.io"
  url "https://github.com/nextflow-io/nextflow/archive/refs/tags/v26.10.3.tar.gz"
  sha256 "6cf4331e5c74f9e55eabb06a72a688f34cc41723cf311ce4c08e6b1d55c44020"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a772192ad4b7f9b79992bf2948d519598d7e9d5fe90a09841124ad2345c09569"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0d041bc33967700e668386261db47df7879c1f2b6c92de09bd17f4a839c2fcf5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9dc5e717ef271d5b4d57aa974df94e5ac022e28883b3771b73945faee06bae75"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1aa6507a1a7541943f33733a102e749481451abf022346225df0e244173abd19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "88dfde44fedc64e406be346d933cc31c271d66ed2ffffcb7a5c9a1976efd7f0f"
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
