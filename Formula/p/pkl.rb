class Pkl < Formula
  desc "CLI for the Pkl programming language"
  homepage "https://pkl-lang.org"
  url "https://github.com/apple/pkl/archive/refs/tags/0.25.3.tar.gz"
  sha256 "864f4971e7f6b3c679703b486a493a3d827efd9c79c04e42859905190ecd02cc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "28923807747cf7b30687a22b9e6948bdec243496a7378bd7c8abe2ae5588c2a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94fc3fd41dbbbba218433b55cdd5da800f252a82432591fc10ae07c6ad5576d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f37040a08d3a9033daf64a50cbfc22ba0b224b9e6d1723da815f8ea2971d1b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "edd860c4207a34d5c853e3f1f227f51838ef56ff5221e4bd94ef57af4d4ff269"
    sha256 cellar: :any_skip_relocation, ventura:        "5bcd8a87301f1a8d3244f6ea32d2c0e6d801d5cccc584ce39a1f5e8191df9d9a"
    sha256 cellar: :any_skip_relocation, monterey:       "eaa1b3838daf98495f4d8a50d905447f3ed4d04805d477d7d89a6a61daf1faf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb743b581d8eeb5b609c86a2c8926c95410e7fd2dceeecff7a6b80fcda40c401"
  end

  depends_on "openjdk" => :build

  uses_from_macos "zlib"

  # To build for macOS/arm64, Pkl relies on a patch that bumps the version of GraalVM.
  # This is not a bug; this is how Pkl is actually built.
  # https://github.com/apple/pkl/blob/277f1e0cdb51deb9fc8af25563eec734bcdf01ba/.circleci/jobs/BuildNativeJob.pkl#L119-L126
  on_macos do
    on_arm do
      patch do
        # Update me during version bump.
        url "https://raw.githubusercontent.com/apple/pkl/c1a9e9e12ff290a1e765ad03db2ec6072f292301/patches/graalVm23.patch"
        sha256 "fbec8d5759b0629c53cad7440dcadb78bdba56f68c36b55cdb9fae14185eeeb6"
      end
    end
  end

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    # Need to set this so that native-image passes through env vars when calling out to the C toolchain.
    # This is only needed for GraalVM 23.0, which is only used when building for macOS/aarch64.
    ENV["NATIVE_IMAGE_DEPRECATED_BUILDER_SANITATION"] = "true" if OS.mac? && Hardware::CPU.arm?

    arch = Hardware::CPU.arm? ? "aarch64" : "amd64"
    job_name = "#{OS.mac? ? "mac" : "linux"}Executable#{arch.capitalize}"

    system "./gradlew", "-DreleaseBuild=true", job_name
    bin.install "pkl-cli/build/executable/pkl-#{OS.mac? ? "macos" : "linux"}-#{arch}" => "pkl"
  end

  test do
    assert_equal "1", pipe_output("#{bin}/pkl eval -x bar -", "bar = 1")

    assert_match version.to_s, shell_output("#{bin}/pkl --version")
  end
end
