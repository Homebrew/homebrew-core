class Pkl < Formula
  desc "CLI for the Pkl programming language"
  homepage "https://pkl-lang.org"
  url "https://github.com/apple/pkl/archive/refs/tags/0.25.3.tar.gz"
  sha256 "864f4971e7f6b3c679703b486a493a3d827efd9c79c04e42859905190ecd02cc"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02ea7423366e9f1a0e42b4ad1eca3760d66e2b4f93cf2fa63fda171173c0b656"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d091b125838eb6a51d41d13d28b3145beb9167de90726173675c42b7bac113f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "235953bd9e72b4522c7bf0b0c556448e52fec962c9e8e5ca511a44e99d48191c"
    sha256 cellar: :any_skip_relocation, sonoma:         "766b2bbb4f4ec439a02abf26b7290ad893d63299f44a3b646d0aa8972b98258a"
    sha256 cellar: :any_skip_relocation, ventura:        "99f8dc74e5feb287ae483e742a20e2be87e578d8c5d7508386e9abfa02feef6f"
    sha256 cellar: :any_skip_relocation, monterey:       "c4f736300847a85d17f14f7815a550ee842a3f2eacad44c15baa0c5ab98b87a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a45d2a4de3b038bffb36eb976ed107f440f65c10b3ba15506d97a6868f653caf"
  end

  # Can change this to 21 in later releases.
  depends_on "openjdk@17" => :build

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
    ENV["JAVA_HOME"] = Formula["openjdk@17"].opt_prefix
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
