class Pkl < Formula
  desc "CLI for the Pkl programming language"
  homepage "https://pkl-lang.org"
  url "https://github.com/apple/pkl/archive/refs/tags/0.30.2.tar.gz"
  sha256 "0b18b123286f4ccf8a063e3fa5129135c1289e5c5d0241afa03d0caa1e367a3a"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9ef5ddf3fbb03401b8f6e07508c32735b71e1e3227cb42fc9a8ae1a13f2ff93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a8294c64953850942595d9a57fbd87049f14447707b24e75c767bb792e56015"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e0f2bf3b0478155a0a999df1021c7b32165919e17da50610d85ae651fac8dfa"
    sha256 cellar: :any_skip_relocation, sonoma:        "38a69ebf9a52eeb7aa84a5b477343b91451c6c0a8312fde3ebb2713406a3559b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a5fdf6293abcd47f762c844360c84c4c95000b65c0713f94cc62d144b516ac7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d69fa2b25f23f5307bba209534ec330c70cbcb985c27e4950fcd5096b469d25"
  end

  depends_on "gradle" => :build
  depends_on "openjdk@21" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
