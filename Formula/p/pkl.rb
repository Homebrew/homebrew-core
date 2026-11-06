class Pkl < Formula
  desc "CLI for the Pkl programming language"
  homepage "https://pkl-lang.org"
  url "https://github.com/apple/pkl/archive/refs/tags/0.33.0.tar.gz"
  sha256 "b232e7149705f4f4922dd27d4693c9ea97fa32b3fec9d45ef6f3297dccf2858c"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "efe4d34cab6fb32495da42a4c6319375b72475149200c7e876d781eb2c924652"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c03841bfdb1b106641d28302820da2296af96de1802aea1cc0fd9f2eaa663745"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "91b1aec7fd836169f5654c22f370317b5f2a0f5200114a65cccf4ccde97a22a7"
    sha256 cellar: :any,                 arm64_linux:       "cf3ef386c5d03fa245212186157f219e80bb957b6a29c95776f3adf88ffff235"
    sha256 cellar: :any,                 x86_64_linux:      "34831d47c53142ca05d8f99c38b25079793775a1b3b4c430c97898174c92a93e"
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
