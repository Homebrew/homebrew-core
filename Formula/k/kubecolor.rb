class Kubecolor < Formula
  desc "Colorize your kubectl output"
  homepage "https://kubecolor.github.io/"
  url "https://github.com/kubecolor/kubecolor/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "1f99891f6ee83cbc179eb264dbf036db316a6fa0c5ec844aaebc59a616a9c1e6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "24293015aeace2e223739c27b8f3fee770d787f23870fc0403346a466599d1bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "783033188019906c58fcccc6efbe51a1c7e34533e6b82b22ae0d872bfd82aeb9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c90bf247e5b6337ec434ea24cbe46eae6ff683c55819e30b4f506391b754bba5"
    sha256 cellar: :any_skip_relocation, sonoma:         "9513adac6122ef9dc7ff26dc35a279e5de1ff564a652040504772bc41c20d96b"
    sha256 cellar: :any_skip_relocation, ventura:        "55b1f2a05345db1c55cc020cb3ba2145b4782059342b65ea17c69186c39ba0a2"
    sha256 cellar: :any_skip_relocation, monterey:       "6ebfe875ccc97ac70c70f1f4dc9f09c191b3142c4d758c20211b8477e8bf42ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e013f7f0b9d754ff25320772c801c266db3aad8d4574318d0a83c1b22c64717c"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli" => :test

  def install
    ldflags = "-s -w -X main.Version=v#{version}"

    system "go", "build", *std_go_args(output: bin/"kubecolor", ldflags:)
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/kubecolor --kubecolor-version 2>&1")
    # kubecolor should consume the '--plain' flag
    assert_match "get pods -o yaml", shell_output("KUBECTL_COMMAND=echo #{bin}/kubecolor get pods --plain -o yaml")
  end
end
