class CloudSqlProxy < Formula
  desc "Utility for connecting securely to your Cloud SQL instances"
  homepage "https://github.com/GoogleCloudPlatform/cloud-sql-proxy"
  url "https://github.com/GoogleCloudPlatform/cloud-sql-proxy/archive/refs/tags/v2.18.2.tar.gz"
  sha256 "98a7eeea8658505ce077728fbc6144f98ad44ba3ec1862e128c995a80c0ea7bf"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/cloud-sql-proxy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a3051648509c57d7bb91b8f986a8a58773009740b13a5fc8ab937cfab6c843a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de3b77fa160d3fd96901f232f04489201d70929424e2b0668182a6889ac3bab0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bfddaf61cbe1885e4f4bb36a1de414209f7e34ca1c2a9d55d3e38be7ef1be2c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "86cce3e6a7fa831e3e70ffa2060cef652e2ef7ae96749d7ccf8074d47203783e"
    sha256 cellar: :any_skip_relocation, sonoma:        "45303b4eea93382f0ed7dbc66e280d485f2009cf5fee48c30da660ebb415b48e"
    sha256 cellar: :any_skip_relocation, ventura:       "0bdb2c15f93d94f7df25a435ef8ac3a63b73c915f439f9b34aa39fc27304e1c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0a8ba8d971b891a9a44f7c9384630de7022d3a237b3d60773b4f9dca631936b"
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
