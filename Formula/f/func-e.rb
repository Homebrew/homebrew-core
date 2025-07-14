class FuncE < Formula
  desc "Easily run Envoy"
  homepage "https://func-e.io"
  url "https://github.com/tetratelabs/func-e/archive/refs/tags/v1.1.5.tar.gz"
  sha256 "ddf3aadf2b52dfbc9f59a8d3cd7324441cacf71491a58b501d74267d497938aa"
  license "Apache-2.0"
  head "https://github.com/tetratelabs/func-e.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "817fd4f4073b7e8ae90709b99b6f1cd67715db3c61656a1c027183c333675489"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3375a703676ff87b126481e99a1fce51e4eafa4c5800669752d396d350347090"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c079783e1b8f84f6a5b6dd531cf1830bfef6bfe6f96e942b0df7ec922c7867d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b130c4a18a0134b7efe54c40d0d013e7887f3253e735ad7433355f58a20f96a"
    sha256 cellar: :any_skip_relocation, ventura:       "334b2c2c46d827321e3e8f6f592b3b580e2b489d3d9ce328616053d6f8df4957"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "708f71cd84ae848d7a7cf8a5d5f03136877e5713df4dceea76aa546664069b38"
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
