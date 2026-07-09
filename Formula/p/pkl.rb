class Pkl < Formula
  desc "CLI for the Pkl programming language"
  homepage "https://pkl-lang.org"
  url "https://github.com/apple/pkl/archive/refs/tags/0.32.0.tar.gz"
  sha256 "b0dcf553f34a9a579a2d9b26ef524b7a45ea1249612d561cfc87cc9dec60c161"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fdcab18138d456fb6881b668da8c61b234ca5706b03897b10e118212a739e2ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb721480d9df39ccfa3daf3254989efa9de2c6ac1b462f457399589de9fbf436"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "323808dbc5bcc8d4db40b0051cb67b62de8db21b53816fcd0bea4080141d1759"
    sha256 cellar: :any_skip_relocation, sonoma:        "07265a693f6211f63c1a431ad4792bdf22c5fe106fde0a088ac481dd90dc673b"
    sha256 cellar: :any,                 arm64_linux:   "d7a0d166c228853aa16ba5361dc09022f3e1234228424f25b64378545024dde5"
    sha256 cellar: :any,                 x86_64_linux:  "6366b82821383b18c6e3c2218c4bb1bc629d71db812affe3c2b331f19ff0bbff"
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
