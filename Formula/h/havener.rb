class Havener < Formula
  desc "Swiss army knife for Kubernetes tasks"
  homepage "https://github.com/homeport/havener"
  url "https://github.com/homeport/havener/archive/refs/tags/v2.2.7.tar.gz"
  sha256 "f923cd42bb4ded5535aa089037bc285110b2bc335ae108553e50ac8bddeafff0"
  license "MIT"
  head "https://github.com/homeport/havener.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4397c0d71d256f7b8421d9594c5ee43c4f13b36b55bd54321537a24377b92545"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ce7e308cf1a51537d8a5a2d48ec5a024d6e7d340ca2f304e279512ba7e49bcd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bfacaa784ba083394e92da83f9bca7ed6881e2c58393e75fd08d69323020087f"
    sha256 cellar: :any_skip_relocation, sonoma:        "532bac41859f345e8109fbf42e907252e63baab9898ae6254f626119b6fc8d6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75dba74d30e26878c3c1640d43bfd02fc403d45b5292f52d19288da461cb3ab0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14c8e859323222fd570e03f56edd2290754bfdc6740c1f3de551683945967cf9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/homeport/havener/internal/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/havener"

    generate_completions_from_executable(bin/"havener", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/havener version")

    assert_match "unable to get access to cluster", shell_output("#{bin}/havener events 2>&1", 1)
  end
end
