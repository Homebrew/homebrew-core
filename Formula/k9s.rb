class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.27.1",
      revision: "d5c9cf5ed5671a1d193b0d397253dfb140370024"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64fbb9329d287eab67a52b0f3575acda8aa055ef7c391e9a3f25e80a6b28ef41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "557ec3ba65be1efb8dec3991860b7d5d1d8abf4b94c5e282856d57df7390be6a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ddfce170931d79567505b487c84833cce392c23ad5f1373b26a6b02fc4ee4684"
    sha256 cellar: :any_skip_relocation, ventura:        "990a4cb96fc39c34b9b964778ef77a376c34b9932110f9e67941d1cf2f98eff2"
    sha256 cellar: :any_skip_relocation, monterey:       "4219779f7bd648af33d9d9efac84bb5adfb1f5da8e8f9f047ecd7ad3fdc2ca16"
    sha256 cellar: :any_skip_relocation, big_sur:        "e904be6004af084a5492e4e7f280ae5a3306944fd72bdcf9820728c99cd5cc2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "298f3e7244e770640178fdf0ec2f6544f191ee061888ec5d605b41d6fe46e48d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
