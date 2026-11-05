class Pkl < Formula
  desc "CLI for the Pkl programming language"
  homepage "https://pkl-lang.org"
  url "https://github.com/apple/pkl/archive/refs/tags/0.33.0.tar.gz"
  sha256 "b232e7149705f4f4922dd27d4693c9ea97fa32b3fec9d45ef6f3297dccf2858c"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aeaf9ab0d02ba647314dc9361bbadf14439b1d7c4c7c01d2c234115f0894f212"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a6f087f7e63e446fbbdb6a384415c08a066b0d866f6766a875d512b6a301f73d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f7561b7aee0420b995b18f0165de4066476aea379ab13c3fc8964b1a6fd5b174"
    sha256 cellar: :any,                 arm64_linux:       "d9e064da1399c0178e81c35497b983ae014847b2ab2d0fa0d38f44fe1f14dcd5"
    sha256 cellar: :any,                 x86_64_linux:      "521d6d0b467cb296706e9b11c832b634b3f91445b854f7cbcd41546f40d3be6c"
  end

  depends_on "gradle" => :build
  depends_on "openjdk@21" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["JAVA_HOME"] = formula_opt_prefix("openjdk@21")

    arch = Hardware::CPU.arm? ? "aarch64" : "amd64"
    job_name = "pkl-cli:#{OS.mac? ? "mac" : "linux"}Executable#{arch.capitalize}"

    args = %W[
      --no-daemon
      -DreleaseBuild=true
      -Dpkl.native-Dpolyglot.engine.userResourceCache=#{HOMEBREW_CACHE}/polyglot-cache
    ]

    system "gradle", *args, job_name
    bin.install "pkl-cli/build/executable/pkl-#{OS.mac? ? "macos" : "linux"}-#{arch}" => "pkl"
    generate_completions_from_executable(bin/"pkl", "shell-completion")
  end

  test do
    assert_equal "1", pipe_output("#{bin}/pkl eval -x bar -", "bar = 1")

    assert_match version.to_s, shell_output("#{bin}/pkl --version")
  end
end
