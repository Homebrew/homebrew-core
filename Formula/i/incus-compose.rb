class IncusCompose < Formula
  desc "Bring the familiar Docker Compose workflow to Incus"
  homepage "https://docs.incus-compose.org"
  url "https://github.com/lxc/incus-compose/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "6e13460f88abd15bbe730269ce4c4f47ce600a2936e15c862de5920dfc369db8"
  license "Apache-2.0"
  head "https://github.com/lxc/incus-compose.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/lxc/incus-compose/cmd/incus-compose/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/incus-compose"
  end

  test do
    (testpath/"compose.yaml").write <<~YAML
      services:
        web:
          image: docker.io/library/alpine:latest
    YAML

    assert_equal "web\n", shell_output("#{bin}/incus-compose config --services")
    assert_match "incus-compose version #{version}",
                 shell_output("#{bin}/incus-compose version")
  end
end
