class Kubecolor < Formula
  desc "Colorize your kubectl output"
  homepage "https://kubecolor.github.io/"
  url "https://github.com/kubecolor/kubecolor/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "47a3d29ec38fd92198ee6e3741cf32ff8b0f2b2eb5b1ce9719f8cfc2bf3a01ff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e82bc57176d5baa75d27f973304632151a48bdbc44c29b03a98501e927fe072"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "154b7c4ac57e92e486ad5598a327a3b2cc5081c9e00ffadef836d58e711e8f8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45229b21a30ebf7f38e9562bf9a3a3b6eed705ce6a007bd1c1042450b8f6e287"
    sha256 cellar: :any_skip_relocation, sonoma:         "f2a40b8a72d70fc73f08f22b53db08d6d1c3d5c4c3709e0ba96b286b65b6640c"
    sha256 cellar: :any_skip_relocation, ventura:        "89e3bf95af211b601f98cd5a6c348e0b1d5ca8fdbb7841c7cdfcff49bf35370e"
    sha256 cellar: :any_skip_relocation, monterey:       "8d293597f936ea42f3d8ab52bb4c440dc839ed5ddeeac87660d13ac9a68dcf35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80ccffc00edab0ab65dfcb01ef3054ad6f5510c6ecca6d7fa37fc53a99010e24"
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
