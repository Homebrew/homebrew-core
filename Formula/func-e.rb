class FuncE < Formula
  desc "Easily run Envoy"
  homepage "https://func-e.io"
  url "https://github.com/tetratelabs/func-e/archive/v1.1.4.tar.gz"
  sha256 "f8829bde3201960edbea764002c16ade4d68e0a7ddc453d042cd1fb5bba3f6d5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e2d726b8a4d2449dee9e16294eaf14e5bbdc1e22bc4b0bb35bcc221faf8f59a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f034e0cdc13ac07a3814ce2554298f9a66938c8116a650ead07fae49b61c445c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f1f8fbb93ab264ec506a0f4bf7092efe15c7eebeb2034da13d987e762de6f96"
    sha256 cellar: :any_skip_relocation, ventura:        "1976afda42dcfc3d3a572b47c8668bb374e9ff23c32609c40583456ca51a78d8"
    sha256 cellar: :any_skip_relocation, monterey:       "95395d54f43e9399c31af694de522725e7624629563d306ae50cbe0f51070d13"
    sha256 cellar: :any_skip_relocation, big_sur:        "088a2729824a34ce2627ac6ac501cb0d37a851ab922e1fa4d241a69e14cd040d"
    sha256 cellar: :any_skip_relocation, catalina:       "a535b83529d5a0e2d2d66cd0809c3a4a932df13dc1d43edaccd6f936799a1c56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ecc20185bdb618f8e4009ef9378f944be0f8de420cbfe184e31d01548d4cef2b"
  end

  depends_on "go" => :build
  # archive-envoy does not support macos-11
  # https://github.com/Homebrew/homebrew-core/pull/119899#issuecomment-1374663837
  depends_on macos: :monterey

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
