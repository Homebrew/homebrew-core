class Pkl < Formula
  desc "CLI for the Pkl programming language"
  homepage "https://pkl-lang.org"
  url "https://github.com/apple/pkl/archive/refs/tags/0.30.2.tar.gz"
  sha256 "0b18b123286f4ccf8a063e3fa5129135c1289e5c5d0241afa03d0caa1e367a3a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af246842685cab337e10b7afea41173572a72d1781600d631a22e5c452cb05f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7cb3bb5ea5719324b9ca79d66e9dc01e44987903b57d7758a2e72c499d7ba9ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9594370d739c0f619cc61e4b4eed44bf2d3b516d74c7213801836e72da37c94a"
    sha256 cellar: :any_skip_relocation, sonoma:        "acbfe35c05d623e0afe70785c64b6a0338d44e88c5cb43535efad4a19259504e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25cb1950d7573395bebbe04df35dfa6c5c26bb5b257a7c838dc42a65d3a2cef8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "981c15e7cf826e119d999507b35b854a50447a6c6e55369f27841fdb9575a087"
  end

  depends_on "gradle" => :build
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
