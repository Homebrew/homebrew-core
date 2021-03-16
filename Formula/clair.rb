class Clair < Formula
  desc "Vulnerability Static Analysis for Containers"
  homepage "https://github.com/quay/clair"
  url "https://github.com/quay/clair/archive/v4.0.3.tar.gz"
  sha256 "0b13307da2e5e058031270e8b0fc26de0be1c4923d50326f9d95be0d1a9fcb13"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "48d2a5e9027dc5e110051baa064b0457d8d2bc3b17c9ee95238feea9dc93b8f7"
    sha256 cellar: :any_skip_relocation, catalina: "ff41504a626bfafbaa6631f648739d1aa8542d07bbbb24f47489917a1ebf1e65"
    sha256 cellar: :any_skip_relocation, mojave:   "21560edcd6808ed82bd2a078fc76238ca6737549a697ac0a4a47fef3d94047ef"
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
