class FuncE < Formula
  desc "Easily run Envoy"
  homepage "https://func-e.io"
  url "https://github.com/tetratelabs/func-e/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "d6e93b3bfe2ea00da45b858cbd9393a8213c1f5be115870b642214dc86323d3c"
  license "Apache-2.0"
  head "https://github.com/tetratelabs/func-e.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50312b58ab29066d403d2223ee4984ca03bfc44e96e3e3e2b9a6848b9c6fb4b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ba95e1ba41daa04ed7162604a23cf2eb49813093f4b0644c4ccc513d863ab16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23f3725f16951e27c77cf1d560a7353122fc6820cdaa70c4f49f9d2f2c6298e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "159edb37bc2a32ee7cb161335fb98fec97c14606aae75b4db9e10591ce4e60be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37abe96369388aa7a44b7fbcc53ee09ae2a523f94c090a420ff5533b8f7d0472"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fdbe813a99dcfa62b20860c1e349000a3cb88c9e60982cbae35c3cf952286a8"
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
    system "go", "build", *std_go_args(ldflags:), "./cmd/func-e"
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
