class Pkl < Formula
  desc "CLI for the Pkl programming language"
  homepage "https://pkl-lang.org"
  url "https://github.com/apple/pkl/archive/refs/tags/0.32.1.tar.gz"
  sha256 "a0c4b4c67711b1e6b79a43ae6833d99a1613d163d2b93323785c8f4699f03fdb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b16ee390b9713158589b7dd095a4931b00c81207c0b0a53f887eb7d2b0a571a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "115fbb80ba094c6f84c4cb43f83bebea6f21fcb0ce2819c58c872d97c66883c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c165aeca1146bcc69f4cbb7864b270153c30cbf98c30b0515811e8f3394c097b"
    sha256 cellar: :any_skip_relocation, sonoma:        "df6dcd16b83d520376cfeb64b7085b5b747e200f6114dcb11420f48a283e2c8e"
    sha256 cellar: :any,                 arm64_linux:   "dfb2d79f373c5befd9bb35a01e711fd292526c5f95abbe140c784d081c08ffa0"
    sha256 cellar: :any,                 x86_64_linux:  "91f78fd26468cd9625aa34be24ae0f008cdbe2e4c7ccfef09a6cdda119139d1f"
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
