class FuncE < Formula
  desc "Easily run Envoy"
  homepage "https://func-e.io"
  url "https://github.com/tetratelabs/func-e/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "f8829bde3201960edbea764002c16ade4d68e0a7ddc453d042cd1fb5bba3f6d5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e97dd0ffc4db5a6ea9e1a95397f5166a25ecc99d71c5dd1d72c88de73af87b50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2f10e2f358de4c6352aa82ad4e2c67fde677a6463e6cf05bebff2058136da34f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83588b07dd168fdf5138e2b55d5388423b8f4c138a18f7de3186fd512f23bdbe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2969bb7e8054052b3736688519486280031fa0224a9d4a9de20394bce7ce514"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ffd03b70a406cdd742c0d12b183401b13e66d1facb57b613d4dc2474aac0d13"
    sha256 cellar: :any_skip_relocation, ventura:        "d00c61a8a944fcf6b8aa3338d755a9534f0cf1379ad94d870c93dc7b203f3b46"
    sha256 cellar: :any_skip_relocation, monterey:       "ecfeb425d1362879536b073f154b3f8957c889288495e5f533a367d1bee3e0e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9271ead514ec571869cb59f8f6eef82935489654b33b25497ce72aa12baff3df"
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
    system "go", "build", *std_go_args(ldflags:)
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
