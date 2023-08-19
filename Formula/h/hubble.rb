class Hubble < Formula
  desc "Network, Service & Security Observability for Kubernetes using eBPF"
  homepage "https://github.com/cilium/hubble"
  url "https://github.com/cilium/hubble/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "309a19c8b4bde3576797a23b8ea797c008111c99e5cdacb0cb40692348f76d53"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "28aa511eeb1e616ab6219f656e9be876269adf51d1304d4c4b2883e474be4b12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6dbf576377f9f97878969f7ceea9bf012403a3ebcf2992b7254d6f5b35b64a4a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a74c75b48d54287454aa9dd69914bc5af43445bc99519e816482d221ba83ac4"
    sha256 cellar: :any_skip_relocation, ventura:        "1f599f82b778231c19cb80f92d94efb2bbf306ff0fbf248e13c34469b6b1404a"
    sha256 cellar: :any_skip_relocation, monterey:       "e4cf2b984e8227e311a54faeb44ed4758e98474a2a8632cb32e28e5a9ef742f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "98cc89eab078ec9fcb74f6275c8a4dd600aa37ed800a5017a714a61161a32537"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86570303a0835fbe606fbe44a266f2cfe00fde514328774e4807353f6d4cf522"
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
