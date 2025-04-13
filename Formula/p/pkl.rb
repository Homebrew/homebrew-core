class Pkl < Formula
  desc "CLI for the Pkl programming language"
  homepage "https://pkl-lang.org"
  url "https://github.com/apple/pkl/archive/refs/tags/0.28.1.tar.gz"
  sha256 "afc5836784563d8012f68930fabdc0ab6d201af0c6f2300bc2a8bb5ee540c3e0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12a262a441d0c8568f0355aa9afefa82462ecb56e99c67732d785fe7d50cdc5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed6cf77211769a7551ade66f24a636890f28a144d0a3dd6eb258d81a64a3c6d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b133fc52f010e03e4939940d8845e36c35be3b57b18d5abbfe0ea818a2fb55b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "61066a3ecd9413817ab7019808a3ec925065df53a2364cc059e99755919186c7"
    sha256 cellar: :any_skip_relocation, ventura:       "49cec8f488cb4126fb8e1dd3efcdd6c8149a077e93eac1cea7986eb0235381c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa4e9979260d0dcadae6db80c85b3a74ae47bc7a12cc0eeb2f0854a8165f2e68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef1965b55aa5fad265c00a1a46c723f42217079a1dec338878625dc1497678ee"
  end

  depends_on "gradle" => :build
  depends_on "openjdk@21" => :build

  uses_from_macos "zlib"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@21"].opt_prefix

    arch = Hardware::CPU.arm? ? "aarch64" : "amd64"
    job_name = "#{OS.mac? ? "mac" : "linux"}Executable#{arch.capitalize}"

    args = %W[
      --no-daemon
      -DreleaseBuild=true
      -Dpkl.native-Dpolyglot.engine.userResourceCache=#{HOMEBREW_CACHE}/polyglot-cache
    ]

    system "gradle", *args, job_name
    bin.install "pkl-cli/build/executable/pkl-#{OS.mac? ? "macos" : "linux"}-#{arch}" => "pkl"
  end

  test do
    assert_equal "1", pipe_output("#{bin}/pkl eval -x bar -", "bar = 1")

    assert_match version.to_s, shell_output("#{bin}/pkl --version")
  end
end
