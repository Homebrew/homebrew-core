class FuncE < Formula
  desc "Easily run Envoy"
  homepage "https://func-e.io"
  url "https://github.com/tetratelabs/func-e/archive/v1.0.0.tar.gz"
  sha256 "22f64a20eeb57752c6dd1a9550abf81ea1a3c2330a197e76751dba727f764c80"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "ab29ff490a15a3c0962bd01d2d9e5450ec0797d65ca4aeaf9506af7565dc55b3"
    sha256 cellar: :any_skip_relocation, catalina:     "24c0f672a30c591123ef9597f61366cd7684248e0a738f46a3e6914f7c51692e"
    sha256 cellar: :any_skip_relocation, mojave:       "380f8e8266e05a65777c4629f160d84f2b71a55763164abdca79bfbd1907ddbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3504164f5a4308eb0224c789289eace1f31d668e6cd0b0a9f79799c387651f8c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags.join(" "))
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
