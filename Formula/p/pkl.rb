class Pkl < Formula
  desc "CLI for the Pkl programming language"
  homepage "https://pkl-lang.org"
  url "https://github.com/apple/pkl/archive/refs/tags/0.31.1.tar.gz"
  sha256 "5dd231807a167283bb9fd67b2c6b8878ad4008efb7780ce89dd3f5bbbbca80d7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11d69fa664d4ea10a7f4b40f46032e2d9b98f8b2c6a08f40fe7a3e942a5b6c04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29307567af7d3ddf99359fa4f17c691f6b35abda0052a7f279f9b89ca8221b7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40f39c58c118ef753b2b4c9c08f5983908d0181db17fbd961d6d20451cbf1fec"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7f908e002a3d7a8f50ac50b22e154ed719232a383aa29784d45c12860b94b6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7291481b8a628034c0cbb1dc1c51a088c640de6c488ac3a01b74f86e07b6d161"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "330d96f95c517ada0a146fd7ba722b75d8bc4b3e6ddf54404544c763c04896de"
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
