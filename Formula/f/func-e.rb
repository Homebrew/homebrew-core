class FuncE < Formula
  desc "Easily run Envoy"
  homepage "https://func-e.io"
  url "https://github.com/tetratelabs/func-e/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "e9c0d130d90e4852ee0f7da71438632e9d12bb58f117fc4aff28bcd6e506dbd1"
  license "Apache-2.0"
  head "https://github.com/tetratelabs/func-e.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bca265c847fafa739ddd06bd000e88c4a6135d9fbb7093e5e3db09c283a9701e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "586d5eb8312d8cbf3103f596e3b764a163e02c0296ce7002805280230508f4b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "586d5eb8312d8cbf3103f596e3b764a163e02c0296ce7002805280230508f4b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "586d5eb8312d8cbf3103f596e3b764a163e02c0296ce7002805280230508f4b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3e77d491e192ec02e4a1c4c46e25939e9ae2e2828eaa9e65aadf32780d51899"
    sha256 cellar: :any_skip_relocation, ventura:       "f3e77d491e192ec02e4a1c4c46e25939e9ae2e2828eaa9e65aadf32780d51899"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d63fc1d4e59e3ac36ff8b550827115444c2be29436397963cd322fff15150ff"
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
