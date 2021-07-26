class FuncE < Formula
  desc "Easily run Envoy"
  homepage "https://func-e.io"
  url "https://github.com/tetratelabs/func-e/archive/v0.6.0.tar.gz"
  sha256 "ecfbe3ee21af3d030772c805e0dcf8a65f5af6841c4cfc729acd3be243057f8c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "7d80712f8c68b2310377681ba169d32785dd051a4bc2106cbb8b773a45f6e201"
    sha256 cellar: :any_skip_relocation, catalina:     "b2ac0446c8fdb271c8fe09475029fee7b424f9f02c5b29a4b8f63766cde70628"
    sha256 cellar: :any_skip_relocation, mojave:       "aebf7879b00cda348d643a358cf0d68bd9fd2052a2995c54025804c4c76c48f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "33fd1ec3483363565566b2b3e522c5a8aba47759683692e685bf145d5408f6fd"
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
