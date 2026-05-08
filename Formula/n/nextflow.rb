class Nextflow < Formula
  desc "Reproducible scientific workflows"
  homepage "https://nextflow.io"
  url "https://github.com/nextflow-io/nextflow/archive/refs/tags/v26.04.0.tar.gz"
  sha256 "e18b757b0540983a2ae2eee235046498650c88431a108a5bb973e7498d960269"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ecffa0444100113860d920fb9745405ade551d3e58ed0360b9519e0e40e00084"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb2b4268d87ad6265d72a51ff3380947e16f99f282a5bbd59545bc24cdda80e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04480dc4fdac3787068ce92b7ee35f0f58aab166ba61a40d4eb92f3502bbc97c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b2cd4dc051b6d8720dd3d30474f59ea5d94a615ebb4d3b0c98d73f8a948fe9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa1720aa6b1a378603f7dae10ad2ba77a1a1ba2813e2a831e77a12e494f21153"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2590d4e8dfc46cbf840034fc5020984ad053e3185bcc9cbeb6a64f62af10a62"
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
