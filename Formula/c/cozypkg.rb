class Cozypkg < Formula
  desc "CLI for managing Cozystack packages"
  homepage "https://github.com/cozystack/cozystack"
  url "https://github.com/cozystack/cozystack/archive/refs/tags/v1.4.3.tar.gz"
  sha256 "3b55ed00ede7c8fa59be2c2027170720f76de234fa37962bbe69ddb151814b49"
  license "Apache-2.0"
  head "https://github.com/cozystack/cozystack.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d103af15b50222b3bce8307bdef9e94864416eaaf97e0b240103aebe7591b7a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0c68693c144f69b87c198ebbb75eba3fedd822b7efe8744f09f78d3aa2dbd23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c341a9445c31eba2647d03c9f3e40dd94111d6bf3bae761a7f10800cc90cc04"
    sha256 cellar: :any_skip_relocation, sonoma:        "b083300b1f12690700b224c203413bd95beedd7173d9da8776c27345b589654b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e15e777bda48d905d75ed475d07f8753e8303f591ccf97265e1ebd81b672c87e"
    sha256 cellar: :any,                 x86_64_linux:  "fda2910967ed5bdd3e876ab94bf25e0514328f9dbf3d6fe56f6d061f1196ea71"
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
