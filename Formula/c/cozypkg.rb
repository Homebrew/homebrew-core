class Cozypkg < Formula
  desc "CLI for managing Cozystack packages"
  homepage "https://cozystack.io"
  url "https://github.com/cozystack/cozystack/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "e8484283f9ce2d9aac4eda45b025112d70cce971cef07aea0f2dc9b4379d8ec8"
  license "Apache-2.0"
  head "https://github.com/cozystack/cozystack.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82402a5f7da5c755c0d88f3d163eb54b4c8c587a5ff365891c6ee6ca99b7704b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4dcffda20fc0b065bdb130125428f618bd790eda7c6c9396eacbc7d730434d14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56e3a848549feefcfb5a7531e3f5fbd9757b56a7de0f1feb3a64caff499154ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0fd13a46310536ae7cd25dff7f2e6a91caede742f48a4ab8cb42e57036e87a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd5340430acafafd974df1570e91e6d57788788425b84c47bcca7ab12d79a554"
    sha256 cellar: :any,                 x86_64_linux:  "e5d5d0ca6951d91a3e4300bc50a420ad3ed010f441a5b9258646eeca7f07341f"
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
