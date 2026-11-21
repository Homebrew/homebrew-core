class Pkl < Formula
  desc "CLI for the Pkl programming language"
  homepage "https://pkl-lang.org"
  url "https://github.com/apple/pkl/archive/refs/tags/0.33.1.tar.gz"
  sha256 "1e244cff4c27cacf800a7db5efeb3c2709364556e67e37bb8369705db49a7a1a"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2df543cdca9ad79ec8b77f496f0c0f3aa9a2aa2eb86614733b2a344e653a3d11"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4985612f128ad00a55071b2ce9fbee9e403332348dfa1e281d472f1cfc8ee379"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c729911422a4635c8e214177b22deffead0678fa6adcd1a07a07e90c62db92eb"
    sha256 cellar: :any,                 arm64_linux:       "4d2584bbea5643a14604f18dc89e8065ebee3f0bc82458e298f8d580926cff5f"
    sha256 cellar: :any,                 x86_64_linux:      "7baad7a6dccf9a64c89dae7aefd33d503dfadddbea17994d79b1d9a5bad4c641"
  end

  depends_on "gradle" => :build
  depends_on "openjdk@21" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["JAVA_HOME"] = dep("openjdk").opt_prefix

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
