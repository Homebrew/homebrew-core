class FuncE < Formula
  desc "Easily run Envoy"
  homepage "https://func-e.io"
  url "https://github.com/tetratelabs/func-e/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "98982018669fe59b2216d43cafac3760bbad346cec93b329d8943f56268b6446"
  license "Apache-2.0"
  head "https://github.com/tetratelabs/func-e.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1922acc4a11707ba15c59d23f70c60ebdce816d7cfb22cc37f3e13b57c39836"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0887b976f48018004c035c1a9b620c488698e1316f90ef6b2ef3a78001b999b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58e046169e62c807df7b7d6adbb2ddabbe3bfba00a0df01eab7d20f5b9f6e4f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "5352a8248748dc4e3fd73f69f82ed7d3cf07efdcd3f6afd6a9032443b674af70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9678a633abf0a74c10eeb6b4d9d4b70d6b3e2a09e7886471efb0b8a5e481ce4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78beeadb22202bb8909f90c60b1422c732658e395ba5f61f5dce68ba071adee8"
  end

  depends_on "go" => :build

  on_macos do
    # archive-envoy does not support macos-11
    # https://github.com/Homebrew/homebrew-core/pull/119899#issuecomment-1374663837
    depends_on macos: :monterey
  end

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
