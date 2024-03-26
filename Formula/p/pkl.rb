class Pkl < Formula
  desc "CLI for the Pkl programming language"
  homepage "https://pkl-lang.org"
  url "https://github.com/apple/pkl/archive/refs/tags/0.25.3.tar.gz"
  sha256 "864f4971e7f6b3c679703b486a493a3d827efd9c79c04e42859905190ecd02cc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "258e24047f0819094d0675c13264590c943fa50dbcd0804b2702a4cd77b1f1a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f1e39d973ef23ab2ca35d36bcc9ee73a91e3fb28028f8bebabaccb91dfc6ba6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdd07ad1623b10e1246d2a029812e74d23f9881acfb7d620fac87fe1ff15fba2"
    sha256 cellar: :any_skip_relocation, sonoma:         "d27479533299925620e258ce90054550499fa5f22f6f9be6b55c7a71d8c57f19"
    sha256 cellar: :any_skip_relocation, ventura:        "9bf5000de455b890618e5133809982134e2a6f8864838919ce0548984410643b"
    sha256 cellar: :any_skip_relocation, monterey:       "255d6a47be95fc0e2fba5462858bc03bfc32ec44c7bdbbbdf5d1d3bd4439c200"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6dd0de922f67ed3abaa3d19d9b03228317766a663844fdd3f4a0a5e19257bc87"
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
