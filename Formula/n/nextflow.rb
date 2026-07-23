class Nextflow < Formula
  desc "Reproducible scientific workflows"
  homepage "https://nextflow.io"
  url "https://github.com/nextflow-io/nextflow/archive/refs/tags/v26.04.6.tar.gz"
  sha256 "485c4413948ddffce2bff02d8df63f6d5bbd88f7fd9c1a63d3a65a3cc8301b19"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5291f7275ff957ba01c87aa12346a8da37c7bd73d7e6ae3aa2799bb7230aefdb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f92c9e70d2ae6abeee7c373916867f9950d3f8ec1195b2ff545dc0f405b4d48a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ea99c36033f4e7dd04706d6ba9ea503c5e9d91740e8282a0e53b4d7c0e55579"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ed00be320de84b4610e870cc3c9b615474e82c2a28a2ec49237242ebb1139c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96328407b1b5e58ae699d019c8126fcc216c04141c6f5e6ed306a8e351b471c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93254d5eaf5e8f0bf1dd5df632f8d848afc38f566dc0a6501ce8a4ff0d9c64fa"
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
