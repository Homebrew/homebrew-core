class Cozypkg < Formula
  desc "CLI for managing Cozystack packages"
  homepage "https://cozystack.io"
  url "https://github.com/cozystack/cozystack/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "c14b9880d1c6ad2a7092a679e903843db6e9cea79d9bbecb9b11fbc36af9b441"
  license "Apache-2.0"
  head "https://github.com/cozystack/cozystack.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c26e69d95b84d88fb3ddc0fa5e56de179f61b63393988af6c70cb7f5244c60b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97b6bf5e4c5ebbdf5c138f707a9ee97ced407bb7f53c84980ffc258d13a5b775"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "beea0b59c96ef6ecd4fa4b644a2cc5d6a2f4d56eb100a2e73ab1104e7d8a3560"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e11f186424e810ad448766f35be44f3468290f83d9c93e33159ac24a6d41827"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "098685be6f75d3f8938f826a95abff6081df3bdc1d5e710d42778fd5b52bc2f1"
    sha256 cellar: :any,                 x86_64_linux:  "7a6942d60140503b95f61b4967402ef4f000024670e9268f78399fba7281f41d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/cozystack/cozystack/cmd/cozypkg/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cozypkg"
    generate_completions_from_executable(bin/"cozypkg", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cozypkg --version")

    ENV["KUBECONFIG"] = testpath/"nonexistent-kubeconfig"
    output = shell_output("#{bin}/cozypkg list 2>&1", 1)
    assert_match "failed to get kubeconfig", output
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
