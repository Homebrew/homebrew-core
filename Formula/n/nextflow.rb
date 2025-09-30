class Nextflow < Formula
  desc "Reproducible scientific workflows"
  homepage "https://nextflow.io"
  # TODO: Check if we can use `openjdk` 25+ when bumping the version.
  url "https://github.com/nextflow-io/nextflow/archive/refs/tags/v25.04.7.tar.gz"
  sha256 "561d55a29bbebd5c9135f82750331262bf034e0bbf56d014fa5115427fa5ed30"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00375687acd20434d16dd7508cb244d94c93e993ca9244e1381a60462404aaa8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d00335e380850ab39fcc468403088045426fd71219097da3558ea21a24c2eee2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee07bbf3ac253b2c439ebdefa18aeaf2d72fb1897ccf0b5d68da6ec10abcd313"
    sha256 cellar: :any_skip_relocation, sonoma:        "cebe98da007e296d029eec5c1faef120900d065d04f87141e653a7f6147f009f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9ed037c229bf69fd021e5a45582f3e4e8284f27ff6630aa959e4f7f508d60bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c99bdad56d1826d3da3f781f733914cdd995dee8d54da24e2e168f498275b468"
  end

  depends_on "gradle" => :build
  # https://github.com/nextflow-io/nextflow/blob/master/docs/install.md#requirements
  depends_on "openjdk@21"

  def install
    # update Foojay plugin for gradle 9 compatibility, upstream pr ref, https://github.com/nextflow-io/nextflow/pull/6388
    inreplace "settings.gradle", "0.7.0", "1.0.0"

    ENV["BUILD_PACK"] = "1"

    system "gradle", "pack", "--no-daemon", "-x", "test"
    libexec.install "build/releases/nextflow-#{version}-dist" => "nextflow"

    (bin/"nextflow").write_env_script libexec/"nextflow", Language::Java.overridable_java_home_env("21")
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
