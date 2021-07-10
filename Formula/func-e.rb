class FuncE < Formula
  desc "Easily run Envoy"
  homepage "https://func-e.io"
  url "https://github.com/tetratelabs/func-e/archive/v0.5.1.tar.gz"
  sha256 "ca30aa0ee97db1a9f935bea2d78fefc6c17cae68947866c0837fa7f8174cbc0f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "baae422ab7b137ae4eb74e977cf21a9faff0b481ffd733787d478915498fcaff"
    sha256 cellar: :any_skip_relocation, catalina:     "6955fb6b70ecd1f6873bec2163fdebeb289d3ae2fdd41c341a97febdf7442f85"
    sha256 cellar: :any_skip_relocation, mojave:       "6cda002dd536d9cb34ad93864344930adac7b12f62f9408711190f6c7a4d4069"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "51db1eb03d9b595353cb3119ec22bb4839d81da9456a28ee24d29f8afbeb1871"
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
