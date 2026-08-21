class Cozypkg < Formula
  desc "CLI for managing Cozystack packages"
  homepage "https://cozystack.io"
  url "https://github.com/cozystack/cozystack/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "5540f6add0da078512bf8791449b12fb0d5120d7a9b7a9b6ab0dfbb1c57a70ba"
  license "Apache-2.0"
  head "https://github.com/cozystack/cozystack.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f6ca117ecd25ccdc242cafd91d7b5b28ddd200d6be0deec27497e3ef059fa53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f8e05e2e1d8aa3d9a7919d9a84242eea3fe581218a6bfcd66e14f403f36e7f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b528f635090e8db37763012a375f185f5462145a4ae3e1a2120c90d06fec7b0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "a209614214245194b7a5a062e1d058bc7d7efd1ee1675e53820ea08a585b75f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2875343ae04323411342cc838624ca53c352d7003df9412c742276c4fc7838c8"
    sha256 cellar: :any,                 x86_64_linux:  "efcebd72df447a4cad1d31074284af0b476c4bc04a0942d969b668a2b7bc4fca"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/cozystack/cozystack/cmd/cozypkg/cmd.Version=#{version}]
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
