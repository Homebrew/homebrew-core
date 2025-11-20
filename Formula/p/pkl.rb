class Pkl < Formula
  desc "CLI for the Pkl programming language"
  homepage "https://pkl-lang.org"
  url "https://github.com/apple/pkl/archive/refs/tags/0.30.0.tar.gz"
  sha256 "f3788e253ca26a5d74ac2f933c0646fa3012af130be084079cc9dee9e283cc40"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6bff17f1d02b703c683b8b70fa9ebb21bb1eafca6a9b9e98993fd36bc34caf50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "766d3e34c1cd773a9f2852c2028b0956717f74cef458f49684ac31ace3b07499"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3284e574abbb612d359236718204f960835353b90f56e0927a130de6d6e5de8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "37b70356b715c322ff5ff6d3cfb045d1cd4e6593129815af3307ce994dc30825"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b749810825d3b91cb521751a61085fe7d5151f02abda1453cbcd60568f8320df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "462e0a5edf8dc2e6f5b5d6c4a905c5da2dc5c3eafb56bef59ec9e51a768a1408"
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
