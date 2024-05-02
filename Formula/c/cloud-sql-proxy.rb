class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "b18bde8c25eccd0c6d590e713f61821626e2d1e3fb6b3d7314b5fa7be265601e"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d9ab2162e2051148b46c4d831112aaa1209fb03b8a648add53b887b9bb0e7a08"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96bfd75bf23dbef7680046a869afe1b3b7352aee11667f9c7238c3c35282a0fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71f246840e802ee6f2f91b78e4a3ea273c0588652687dcae9dd2040dd7ce07e4"
    sha256 cellar: :any_skip_relocation, sonoma:         "5db5295e8da9e37ba49df39a15f923f3f2dec53e997ed1f6578b2726c2fd28d2"
    sha256 cellar: :any_skip_relocation, ventura:        "952f62fe2951203cb61e750803b8f9981478e8b5ffd461c35b7caa32efadfbfb"
    sha256 cellar: :any_skip_relocation, monterey:       "5617d4f64c435ca51bba9a5cc4e14afa6b2a8173510f7f9322b2915e9a1e4c9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97ee47e81f5a3cc5db4843dd444487bb922803a3aa82efc34aa7585d44a7ecc2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "cloud-sql-proxy version #{version}", shell_output("#{bin}/cloud-sql-proxy --version")
    assert_match "could not find default credentials", shell_output("#{bin}/cloud-sql-proxy test 2>&1", 1)
  end
end
