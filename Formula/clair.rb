class Clair < Formula
  desc "Vulnerability Static Analysis for Containers"
  homepage "https://github.com/quay/clair"
  url "https://github.com/quay/clair/archive/v4.0.2.tar.gz"
  sha256 "fc785fa5da0f3e5ca3f709d562131bc944967f65a4bc1668565b37ae4f1d174b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "ce42a64fe50ef146cfe130e109b70535a6a08caa7036c85ee15ac9d95ad813d7"
    sha256 cellar: :any_skip_relocation, catalina: "9016b230520b4832f63ec4b7ae2c57a420215170e778cae3fd7e147787a5eee5"
    sha256 cellar: :any_skip_relocation, mojave:   "9f0252ffe42185082e87045366c324614ff7f137378cdeebd303d19eef859ea2"
  end

  depends_on "go" => :build
  depends_on "rpm"
  depends_on "xz"

  # revert back to config.yaml.sample
  # remove in next release
  resource "test_resource" do
    url "https://raw.githubusercontent.com/quay/clair/6e195c99a14139360c8d09f90c94024eb7d27b67/config.yaml.sample"
    sha256 "4efbe587cdc074d29cfa9fe539d97304a33c28fcaeb986d6c8e4db7f8c705812"
  end

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ].join(" ")

    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/clair"
    (etc/"clair").install resource("test_resource")
  end

  test do
    cp etc/"clair/config.yaml.sample", testpath
    output = shell_output("#{bin}/clair -conf #{testpath}/config.yaml.sample -mode combo 2>&1", 1)
    # requires a Postgres database
    assert_match "initialized failed: failed to initialize libindex: failed to create ConnPool", output
  end
end
