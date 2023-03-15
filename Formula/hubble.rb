class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://github.com/cilium/hubble/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "13736d48c180d1a78de91e5b99c3baa232f21cbeccf89bd4fd3f8c500e5a445a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ac047de0f2b158136718f36522fc3e9b10c5fa8882bce9644e8e305a27316be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e576333fd18f315702afafa419b4cf917a5f37f4a78a0c653f327bc78e761b40"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e9b3552cca173dc906f8db6150ce4ee92d70345d1713221bad54e1696c0daf4"
    sha256 cellar: :any_skip_relocation, ventura:        "163a135af82aa9e2135f089ad56b6d3e130416a14fe7d646aad5be63f6ddf4ea"
    sha256 cellar: :any_skip_relocation, monterey:       "c0c987599d901fb489461058acfcfa3fb315a56181a7664a51d4cc794e320602"
    sha256 cellar: :any_skip_relocation, big_sur:        "799d3a6f1eaf7e434092b610ea2aea4b320ba3aea3ffb40e43619725c784dd61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f9e782b8602c1242b8c3590276e9a3d0388b2e5e0fbc51515999dbb93a36f5d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/hubble/pkg.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"hubble", "completion")
  end

  test do
    assert_match(/tls-allow-insecure:/, shell_output("#{bin}/hubble config get"))
  end
end
