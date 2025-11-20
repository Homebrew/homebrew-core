class FuncE < Formula
  desc "Easily run Envoy"
  homepage "https://func-e.io"
  url "https://github.com/tetratelabs/func-e/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "ed4d8df5cb269f7d5aee2eb0b20bfe683c611344634b0d0393db035c2554511f"
  license "Apache-2.0"
  head "https://github.com/tetratelabs/func-e.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa16144b9740297e39443c25bcdd3e73afee4e105f88a09221796c2480defef0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c94312275f4895b36dfe06ecd082c16511df49b6c1d34c2f33bc76b260296f30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c11bfc292ab7c3b8d2f4a6cfdde45860ea716809fdf97f04ea6c0aa4adf5c33"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fa50bff6d7e46378ed1de3385f634d6022cf9e22bb21e4cf7a6181fc4ff2def"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1af8e7a36e827f8d13f19403c4879395b8da1ba0acb7875ab7e5b2b94fd5d08a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f43e20940f27963a438b5e99db3119e0ae66378c0f320aeed27db844664fd41"
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
