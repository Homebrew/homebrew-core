class Clair < Formula
  desc "Vulnerability Static Analysis for Containers"
  homepage "https://github.com/quay/clair"
  url "https://github.com/quay/clair/archive/v4.0.5.tar.gz"
  sha256 "e6ce6ff418bb399ef41b56bd55057d24913ecd96a7039485e1b80cea5387baad"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "2f6a4f3946354c4572cf8fb81f0ba1cdf92841dbdcd7fd9803931ea04398aefe"
    sha256 cellar: :any_skip_relocation, catalina: "16f77b7b1b96e5142d581074e12e981aa64856ce9f42f7b84a4b6f81fa781758"
    sha256 cellar: :any_skip_relocation, mojave:   "d1b5a96a051fa06545b73a1f944613abaac9a3ce45cc71aa8df87e8bc6213cf0"
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
