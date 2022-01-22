class FuncE < Formula
  desc "Easily run Envoy"
  homepage "https://func-e.io"
  url "https://github.com/tetratelabs/func-e/archive/v1.1.2.tar.gz"
  sha256 "4a7d5f295adc6715df37b2503b9fb73a08b683ebeab5bf9b120c4cbf6ad1423b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:     "6e698206bb39d8c8abb131ec73961ed41a461e5477cdfed7c871583a24ee94b9"
    sha256 cellar: :any_skip_relocation, big_sur:      "63999b444ad0ade614290b57b8962db7f111e1c26ba943092efff5b1eb738841"
    sha256 cellar: :any_skip_relocation, catalina:     "2f8655a3e650159fef5868347ae1248a6e7f115504fe4dcdfbb14c9a06f59dc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "58a765e6c1de9df1f95b73c8e604d4f1bb611a42d5f6575c10ee3326d82c69aa"
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
