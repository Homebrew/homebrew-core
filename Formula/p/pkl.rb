class Pkl < Formula
  desc "CLI for the Pkl programming language"
  homepage "https://pkl-lang.org"
  url "https://github.com/apple/pkl/archive/refs/tags/0.28.2.tar.gz"
  sha256 "b63a0c672a7b810daf4606d37dc18d37b012a0fc011df5c5c2c96d708227a18b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9f7f1777064b70061f7b7b8bdd1c493b034397af8d1728641e69f963bb03465"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c21a4185136ae375d83cc589fa1be4626513e4fa0c97da3184ebc335f0e5fa6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "70d649fdc593bd1d7ce6dee2edf6e62366e4579675d5e450bd6d17222ec0667f"
    sha256 cellar: :any_skip_relocation, sonoma:        "511cecba0df4e994d99575832ddc03a1c388a82f32bcb119cb094996416b2e90"
    sha256 cellar: :any_skip_relocation, ventura:       "93c166e637de735ce561dece7bc33a32668edc667d15d5875173a62b476fa03e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed219ebb3e536eb5406298c4e3149cca22ba23fe41279877ebfcd55401331c3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e882f2790dc353736341ad0d08a6b006cf779bca81eb67ce3935f597c944e87c"
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
