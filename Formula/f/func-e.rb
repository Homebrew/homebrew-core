class FuncE < Formula
  desc "Easily run Envoy"
  homepage "https://func-e.io"
  url "https://github.com/tetratelabs/func-e/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "2648439feeb98f0e3dd7b8b5d3381b80b2b4a6793385b255d152db4da3cad3f3"
  license "Apache-2.0"
  head "https://github.com/tetratelabs/func-e.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8716e84aafaf3e684b7b15d6086597d0926e97f8b05c5712c63ea7518476351a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4e518d3252072257a7e1bbd48d104d683c0e9fb622474e4cce467fd9a26578c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b1b1cb08ed33666bbeb46b5a7703a160c89536e47a1bfeb8aa3937086aa4017"
    sha256 cellar: :any_skip_relocation, sonoma:        "86420a590f773ec6077060e05603e3990ad5b7c49496df302d5e344206d2eefa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a176ca8b0fb670b871bb953db3d3f51dee455fed55a7fa0e004a07f35b9e8ed7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "233527192a1e7e66de8c6dca6af4a9107fab3753e23f7444fad6b9fed448af17"
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
