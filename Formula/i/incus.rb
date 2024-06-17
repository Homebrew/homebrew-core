class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https://linuxcontainers.org/incus"
  url "https://linuxcontainers.org/downloads/incus/incus-6.2.tar.xz"
  sha256 "798fa22b1f2b1375a5220f860318f1e37b5b272db48d66df1bbe5996ebad1279"
  license "Apache-2.0"
  head "https://github.com/lxc/incus.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "523fe004532aec6a1745e2a05aedbcd679c802c2e6ff5a6a6eba3aecf41dca35"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07e5d12e9c307eeca108135e9b1448f74176caef259b884832410dc016d9e732"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fce30d94b17fbbf96c13a868f3ac9b5d43d302c28daa700589c463f98f17dbed"
    sha256 cellar: :any_skip_relocation, sonoma:         "78ca51458bbd8579a808deb4421878bf3fc4118bb2549703929fa15578230b44"
    sha256 cellar: :any_skip_relocation, ventura:        "137579ef3785073524b2fbaffbca18bd0826a99cd0f27fa7e94015dc2c7cea47"
    sha256 cellar: :any_skip_relocation, monterey:       "e6bcc29ec1ee29de95178f49db43952e0b4d74b63c8ca52cfbed8a3d24b616df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c00c519d634bd1275a1421a1837fde91d7657331f7f84bab7882874271f405f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/incus"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/incus remote list --format json"))
    assert_equal "https://images.linuxcontainers.org", output["images"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}/incus --version")
  end
end
