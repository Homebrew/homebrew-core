class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https://k8sgpt.ai/"
  url "https://github.com/k8sgpt-ai/k8sgpt/archive/refs/tags/v0.4.36.tar.gz"
  sha256 "81b9fc2cb52ba44a3b80fe5d69cfcd43dd389ac29d5e2d46c14f9cfa6e2f87c2"
  license "Apache-2.0"
  head "https://github.com/k8sgpt-ai/k8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8bf8bf23f7d97ec35519a66f6b5278cbc70e2937d5a6b023888a1e8a5038205"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84e54de311194a20cac240b04631e3db9c174d8d4126476c3f6ed8d461a00998"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e755e6f0410457650f42aa325deca7f728ef15bc28cdb3d9a18e206f4fd05e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "17dddb64ab65bff08a557e1d974516a2c2c34296d75c73c5649db40af9ae568c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b927a8f2c6adee7ca9c8735bb97ebd8b105e6a5a65996b1164d48e7a59ef94c9"
    sha256 cellar: :any,                 x86_64_linux:  "4a59e638d2ebe30d54ab27b431da44e3d96c1f8b119563616316882099641801"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k8sgpt", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/k8sgpt analyze --explain --filter=Service", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output

    assert_match version.to_s, shell_output("#{bin}/k8sgpt version")
  end
end
