class FuncE < Formula
  desc "Easily run Envoy"
  homepage "https://func-e.io"
  url "https://github.com/tetratelabs/func-e/archive/v1.1.3.tar.gz"
  sha256 "2dd1598efd743dae38a55f6943eaa62d17f2db9996be249edf5e52495338b5e9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f034e0cdc13ac07a3814ce2554298f9a66938c8116a650ead07fae49b61c445c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f1f8fbb93ab264ec506a0f4bf7092efe15c7eebeb2034da13d987e762de6f96"
    sha256 cellar: :any_skip_relocation, monterey:       "95395d54f43e9399c31af694de522725e7624629563d306ae50cbe0f51070d13"
    sha256 cellar: :any_skip_relocation, big_sur:        "088a2729824a34ce2627ac6ac501cb0d37a851ab922e1fa4d241a69e14cd040d"
    sha256 cellar: :any_skip_relocation, catalina:       "a535b83529d5a0e2d2d66cd0809c3a4a932df13dc1d43edaccd6f936799a1c56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecc20185bdb618f8e4009ef9378f944be0f8de420cbfe184e31d01548d4cef2b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    func_e_home = testpath/".func-e"
    ENV["FUNC_E_HOME"] = func_e_home

    # While this says "--version", this is a legitimate test as the --version is interpreted by Envoy.
    # Specifically, func-e downloads and installs Envoy. Finally, it runs `envoy --version`
    run_output = shell_output("#{bin}/func-e run --version")

    # We intentionally aren't choosing an Envoy version. The version file will have the last minor. Ex. 1.19
    installed_envoy_minor = (func_e_home/"version").read
    # Use a glob to resolve the full path to Envoy's binary. The dist is under the patch version. Ex. 1.19.1
    envoy_bin = func_e_home.glob("versions/#{installed_envoy_minor}.*/bin/envoy").first
    assert_path_exists envoy_bin

    # Test output from the `envoy --version`. This uses a regex because we won't know the commit etc used. Ex.
    # envoy  version: 98c1c9e9a40804b93b074badad1cdf284b47d58b/1.18.3/Modified/RELEASE/BoringSSL
    assert_match %r{envoy +version: [a-f0-9]{40}/#{installed_envoy_minor}\.[0-9]+/}, run_output
  end
end
