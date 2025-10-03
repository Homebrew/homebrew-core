class Pkl < Formula
  desc "CLI for the Pkl programming language"
  homepage "https://pkl-lang.org"
  url "https://github.com/apple/pkl/archive/refs/tags/0.29.1.tar.gz"
  sha256 "cafda453d8cd0e7783bd48c7b7d6d1b43b527d163f87bd7a852c71233ec873c9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac5da605468b0bf3562c0d6f31cb1dfdf8f389e4f8cf73db293df0fc185066ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13d5821b098a5d299fc46879577ae6e9a34ebe05d45f76cb6c36571ed50d8379"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "329a933fca1bbe973f9e231f855e2895b09fc56d8038a3e8b7ac77b413090461"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c00368f1c7d4e8da6ec7270ad03335d3e280ab2f13a11b441d2d58ba6a4418ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b19578d3a1792200a5462555f301b7e919b94f242fb74e3cf6ed0548f96b471"
    sha256 cellar: :any_skip_relocation, ventura:       "6148f54d2dbaa8854f000f1e32caf29bb62975c15629ee92ced4f72ac4301263"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01682d4cab65dce2433a14a11129eeda515602a62ce3873a07c70a69f005b78b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "386b15f1ca707e6c4cf1f5c95cc09cfb0f064560f82f8526201ffe942db448c2"
  end

  depends_on "gradle@8" => :build
  depends_on "openjdk@21" => :build

  uses_from_macos "zlib"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@21"].opt_prefix

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
