class Kubespy < Formula
  desc "Tools for observing Kubernetes resources in realtime"
  homepage "https://github.com/pulumi/kubespy"
  url "https://github.com/pulumi/kubespy/archive/v0.6.2.tar.gz"
  sha256 "17a1c75357557f2caa9a6f781bcf628323b4cae42a05b123cd2d73f0bf9bd73c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "afdb0255bdec57e90e6ce49613fdfe66d4dc83bd7b3b6caf8e166bc69c275071"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d2185d63e9cd41c6d28aa2a1433d43ea08b334d326ffebe29ea7b63baaeb056"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06167bc087e73dcd0e5a49f6e71b6a73fcba89989a9fee7c37ddb9cc68d5c076"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4d63724253e368ba65d670a373a7581ed55abb56ae4a28deb053f4276434cf0"
    sha256 cellar: :any_skip_relocation, sonoma:         "a3e78e8b3fefd7e7a822fe531cdb6fa1ee5d2d85f936062e98be85b0e5e14c4d"
    sha256 cellar: :any_skip_relocation, ventura:        "383354122647beb2a09d537c82255f6fedddc606db8f40d55e036156ad7f600c"
    sha256 cellar: :any_skip_relocation, monterey:       "db91d1f2fe51df06c3abf142758420bd969ca20a0fd5e575abf7afe2689cbc12"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ea4bfb1eb75049dfe3a2a5dcf21166c7c060a47fa04dd75452eb8dff9976620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ad332e5eb24531a527b253931487b8f2935cb190ccd72ecb98b2141b91f8d68"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/pulumi/kubespy/version.Version=#{version}")

    generate_completions_from_executable(bin/"kubespy", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubespy version")

    assert_match "invalid configuration: no configuration has been provided",
                 shell_output("#{bin}/kubespy status v1 Pod nginx 2>&1", 1)
  end
end
