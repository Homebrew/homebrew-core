class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https://glasskube.dev/products/package-manager/docs/"
  url "https://github.com/glasskube/glasskube/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "c044187e49683b39aa89c26bc02dab38781578c24b6ab277c0a58ae811066996"
  license "Apache-2.0"
  head "https://github.com/glasskube/glasskube.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3babde1be2c32139d55c3d9d357e0dc0647acf1c51a7969c32fb219e01bf7671"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3babde1be2c32139d55c3d9d357e0dc0647acf1c51a7969c32fb219e01bf7671"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3babde1be2c32139d55c3d9d357e0dc0647acf1c51a7969c32fb219e01bf7671"
    sha256 cellar: :any_skip_relocation, sonoma:        "12cdfcca0e5bbcc188c778493e12fc1f0062e737d6a59f4942192bf8cab55810"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f060357190000ffc79417336afd8b6b0abcfec355015e4a9502ffca4ba7bdd3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f74d440bd5ff5936c0ee805fa757c79f0891b65d4ba3c232da4caa69901264c4"
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

    generate_completions_from_executable(bin/"glasskube", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/glasskube bootstrap --type slim 2>&1", 1)
    assert_match "Your kubeconfig file is either empty or missing!", output

    assert_match version.to_s, shell_output("#{bin}/glasskube --version")
  end
end
