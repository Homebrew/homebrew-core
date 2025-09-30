class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://github.com/cilium/hubble/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "29f4a452a360829a184d5e20b4d6c54fc96c982f91fe3569cd26b0fec35cf010"
  license "Apache-2.0"
  head "https://github.com/cilium/hubble.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c8c6991264c6cad9b99bc49dadd897ffe71c6638605da62b3888ea2500d98c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f09f18708146f7e6a6c3b258332d73f8bc5b3e151160d989f97f11cee9dededd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "798337f3f2a8235c436074330de469dde784b93de77604f22b9123894bd7bfa5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d52c44bc0824c1fd267fcb222c6c34e379843424735a19793f3d9b3d18fec5aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "77d3fc957c30108100785b703285c3314c644596a833152a03a5359649dea48b"
    sha256 cellar: :any_skip_relocation, ventura:       "d167b1c9d6f9cde55d5051d551afa2110363d9ad0b788572fbd02ce407e0f19a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97992e9931442f1137182f06ee8838502226a04153658be89efcf145fe98cf1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc8bfc1499cc383def0d2f53bacb547ad74bd5571910ce1477cd65572b0def61"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/cilium/hubble/pkg.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"hubble", "completion")
  end

  test do
    assert_match(/tls-allow-insecure:/, shell_output("#{bin}/hubble config get"))
    assert_match version.to_s, shell_output("#{bin}/hubble version")
  end
end
