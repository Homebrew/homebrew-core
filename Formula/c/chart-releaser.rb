class ChartReleaser < Formula
  desc "Hosting Helm Charts via GitHub Pages and Releases"
  homepage "https://github.com/helm/chart-releaser/"
  url "https://github.com/helm/chart-releaser/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "de29b9f4f62145a08e55fd74ca1068fb8db61432aa39b84b3b3314f1d0846d5a"
  license "Apache-2.0"
  head "https://github.com/helm/chart-releaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90701fd2d173081f91119e9817a89a171d2e5b170a888f63105cd42a158109b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f5adc463c318777895b3370b7b876d3533b513e60fb364226ec4563bc29da3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5d1c4cb8b0678c91261d8ef50caa05bbc99fc063dfbeeb26e8b25a7e0573719a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8589497b906501194855f60a2cbb4c576b666627e805525c77f94eb941cd0cfb"
    sha256 cellar: :any_skip_relocation, ventura:       "18663efa332fd116acd16530d4ae73faa0eba3b21b2f8ce7697098203eee040d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c239222a325cd05f50a7ebc59249d45e61bcc63227580d5f7314c821e0b8832c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ebf5848614eb2953aa6f3a6d234a5f2d86957ffdb430aaac56cb919f1ceb95e"
  end

  depends_on "go" => :build
  depends_on "helm" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/helm/chart-releaser/cr/cmd.Version=#{version}
      -X github.com/helm/chart-releaser/cr/cmd.GitCommit=#{tap.user}
      -X github.com/helm/chart-releaser/cr/cmd.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"cr"), "./cr"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cr version")

    system "helm", "create", "testchart"
    system bin/"cr", "package", "--package-path", testpath/"packages", testpath/"testchart"
    assert_path_exists testpath/"packages/testchart-0.1.0.tgz"
  end
end
