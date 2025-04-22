class Qbec < Formula
  desc "Configure Kubernetes objects on multiple clusters using jsonnet"
  homepage "https://qbec.io"
  url "https://github.com/splunk/qbec/archive/refs/tags/v0.16.3.tar.gz"
  sha256 "1dfdd8f4db74ba3115c56704e99b26d072ad72aa14f84d5af8e1c419126bb122"
  license "Apache-2.0"
  head "https://github.com/splunk/qbec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87c759042432ed77117d61eff8a1f8e5cbe25e2672df0e2706896be8e78f483c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "290a9669a65e80fd5c4d7045c7a74b8f2d18eabf0083899f733a7ee3caf4675e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d943895d5ab80e6a17ea36217a092f79cd107f10c4e12aaf0462d9742e7d54f"
    sha256 cellar: :any_skip_relocation, sonoma:        "026af3dda4133c5fbc36e7c2ae7665dd4b701fb01f4f4619b64c37e88778ef8b"
    sha256 cellar: :any_skip_relocation, ventura:       "02f0fcba10301230efdec142e29c9b3c09286e1ebf133d3a00cac08ce27aac62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92f342e9bdf53d997f34eba29e635263ba0741935b5110c4d1e7152d3227c6e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78a97847c98ce06a3a868af4e5bb008e16dd24d86a219c2ef6607637bdfbc7a0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/splunk/qbec/internal/commands.version=#{version}
      -X github.com/splunk/qbec/internal/commands.commit=#{tap.user}
      -X github.com/splunk/qbec/internal/commands.goVersion=#{Formula["go"].version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    # only support bash at the moment
    generate_completions_from_executable(bin/"qbec", "completion", shells: [:bash])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qbec version")

    system bin/"qbec", "init", "test"
    assert_path_exists testpath/"test/environments/base.libsonnet"
    assert_match "apiVersion: qbec.io/v1alpha1", (testpath/"test/qbec.yaml").read
  end
end
