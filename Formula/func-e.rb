class FuncE < Formula
  desc "Easily run Envoy"
  homepage "https://func-e.io"
  url "https://github.com/tetratelabs/func-e/archive/v0.7.0.tar.gz"
  sha256 "9177205e91d2d47fd63964cdbf87e22cb75a14ca3f38070f50f7598793c7246e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "35ee30e4ca621052dd0e01698325b2c3853d6f47597f1d280411cbc1ee87c04c"
    sha256 cellar: :any_skip_relocation, catalina:     "2dd53f22ddf7d626c6b0f24284f1254fded2617d9d43d70098cf6e04ac30ad01"
    sha256 cellar: :any_skip_relocation, mojave:       "0d930314dee7edc64c5e2cb24e089d79a39464a47bd1f9a5493c9ae9615ed5de"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4fd94b1130fad111778526b9af45b9fd7ed9f4eac7c4f744aa26e1b7df495fd7"
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

    # We intentionally aren't choosing an Envoy version, so we need to read the version file to figure it out.
    installed_envoy_version = (func_e_home/"version").read
    envoy_bin = "#{func_e_home}/versions/#{installed_envoy_version}/bin/envoy"
    assert_path_exists envoy_bin

    # Test output from the `envoy --version`. This uses a regex because we won't know the commit etc used. Ex.
    # envoy  version: 98c1c9e9a40804b93b074badad1cdf284b47d58b/1.18.3/Modified/RELEASE/BoringSSL
    assert_match %r{envoy +version: [a-f0-9]{40}/#{installed_envoy_version}/}, run_output
  end
end
