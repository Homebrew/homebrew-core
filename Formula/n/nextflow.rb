class Nextflow < Formula
  desc "Reproducible scientific workflows"
  homepage "https://nextflow.io"
  url "https://github.com/nextflow-io/nextflow/archive/refs/tags/v25.04.7.tar.gz"
  sha256 "561d55a29bbebd5c9135f82750331262bf034e0bbf56d014fa5115427fa5ed30"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93cdc2a01bee09458e4c7321abeeba61ffb078370b535fbf2f4c5b2e72b8a55b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f73522dd924f7f30ae3c0ab929c0004444bfc6936f749eb748750c93ba81534e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3c7682b4a6a29b452089ad7876d124df96eba48f320aab1b1bfcbafe94fec08"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd5594c626cf7f152bc96d505fe531acaa4a7fc19565b4a131e37fbb695a5582"
    sha256 cellar: :any_skip_relocation, sonoma:        "00dd743d1065b998d8b4a1bae8c5adb439ea29129a4bae07dd4a6266b50cd244"
    sha256 cellar: :any_skip_relocation, ventura:       "e4f41b86dc23da1fdd6cd38578aba628f64ddaadff71124d98636703e7a2f6e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12b7951d5ddc42903463e5926cb1d8224d4db6f430432266d0b2e7aebb853dba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3af062465ad60760376052dc480fa4f0f783bbb8ce1477cf0ae173c7d897cb9d"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    # update Foojay plugin for gradle 9 compatibility, upstream pr ref, https://github.com/nextflow-io/nextflow/pull/6388
    inreplace "settings.gradle", "0.7.0", "1.0.0"

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
