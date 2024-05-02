class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https://glasskube.dev/"
  url "https://github.com/glasskube/glasskube/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "20df3c70eae8a311a9dd49f6f102175bc711264aec0f89671d26f409ce12240c"
  license "Apache-2.0"
  head "https://github.com/glasskube/glasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad961a684c75fb3b57bf09b7d9878040d32c60c9061ff09f300bfb40b7af601e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c79bc8c86fd7944c46b0bcb9baf343da2ee04689b1eb81ebdaa9f2bf0aa505f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "299c3da92e13b97ddbd34e39e7dc6fb707506969d1d64b1cfd158fcc4b90f2eb"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7e50d229c1f6beafa8e30d4634eae94aa4f5e1fad534cfb27d67b9d414ce352"
    sha256 cellar: :any_skip_relocation, ventura:        "ad36e99506387a3ec26bedff737ff92605e3dae1ea2d9f7e59b671187d1a8b31"
    sha256 cellar: :any_skip_relocation, monterey:       "7d1ea412e734c25b1131fba935307e57ebee2e24a887c19e6628e879774fb581"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b00f292e59bab33de0c8aebeefe4d34afcd674dee7fab728f6678537c09713ca"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/glasskube/glasskube/internal/config.Version=#{version}
      -X github.com/glasskube/glasskube/internal/config.Commit=#{tap.user}
      -X github.com/glasskube/glasskube/internal/config.Date=#{time.iso8601}
    ]

    system "make", "web"
    system "go", "build", *std_go_args(ldflags:), "./cmd/glasskube"

    generate_completions_from_executable(bin/"glasskube", "completion")
  end

  test do
    output = shell_output("#{bin}/glasskube bootstrap --type slim 2>&1", 1)
    assert_match "Your kubeconfig file is either empty or missing!", output

    assert_match version.to_s, shell_output("#{bin}/glasskube --version")
  end
end
