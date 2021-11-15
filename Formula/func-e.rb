class FuncE < Formula
  desc "Easily run Envoy"
  homepage "https://func-e.io"
  url "https://github.com/tetratelabs/func-e/archive/v1.1.0.tar.gz"
  sha256 "0e5d76b5907142800e67417684996f57b0851b55cdb464e3c79e89d54c802fc2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "20d2ff6b6c91e7776e13bfdf912abbc7a1986e67c93aceb3f892bc8e8337ee0a"
    sha256 cellar: :any_skip_relocation, catalina:     "3c558204d6d49bc30c37880179416b52c5b10d150ca3b4e4378d0823e013c75b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f3de432998e3ddc1b559e8438798e64f4645f4d6ad23addf28a5f15dcc7d16bc"
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
