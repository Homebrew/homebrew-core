class Glasskube < Formula
  desc "Missing Package Manager for Kubernetes"
  homepage "https://glasskube.dev/"
  url "https://github.com/glasskube/glasskube/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "11ec36c58c321d0cf8b9c137cc26e8020a938548f40795160a76a18bcde25a7b"
  license "Apache-2.0"
  head "https://github.com/glasskube/glasskube.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb1e8e26056f0be98f3a9380bf6b523eb539e41aec1e409e52362d3d95c1d435"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6d4112b83622762b6b40b37efd71e7ca5f1d1ba24f19536c9f82e52f8f50ed6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8f249bec821d6ca3346069292875b41cd7199174851e5ebbe790f0b16745dc4"
    sha256 cellar: :any_skip_relocation, sonoma:         "5f744d4690d7d9269b5edd723a92807ae7e334f84e053cf974e3e5bc7c530857"
    sha256 cellar: :any_skip_relocation, ventura:        "31b180d89d4909a3073631cc704ef6a1ca6169cee476cacb5281bd44e47418d4"
    sha256 cellar: :any_skip_relocation, monterey:       "c94df6c281e1c8e3a2e56168ab895759622f47c322bf6f37d5f248ba88dcd3a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2193a329817ab61023bd1fbce06d37066b691d7156622188f8d86e40a52fd49"
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
