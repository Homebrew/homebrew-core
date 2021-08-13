class FuncE < Formula
  desc "Easily run Envoy"
  homepage "https://func-e.io"
  url "https://github.com/tetratelabs/func-e/archive/v0.7.0.tar.gz"
  sha256 "9177205e91d2d47fd63964cdbf87e22cb75a14ca3f38070f50f7598793c7246e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "8ae211ca3d4d4fd50639739296063159ca13dc3fa360b217a2f63f1a194bc589"
    sha256 cellar: :any_skip_relocation, catalina:     "241862609747afe310a5f5808df369b934a7f50e49cdcae99734a03377a0b0e2"
    sha256 cellar: :any_skip_relocation, mojave:       "515a5d570cedfe8e1098db431193d3d5e5e9b5a6f0acc1763ffbea6355408309"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a84ccff7c0ccef38b8ad9c8473ca111360345134eb5a0900f1ff4fbb0ff10bd3"
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
