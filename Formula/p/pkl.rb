class Pkl < Formula
  desc "CLI for the Pkl programming language"
  homepage "https://pkl-lang.org"
  url "https://github.com/apple/pkl/archive/refs/tags/0.26.3.tar.gz"
  sha256 "80f77fc551bc6ba9460476676e9440f42e9a69852e15500dfb13b4378291290b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "39445d274181a050e8e4f587561c055e0372faf9eea2eba15026c223f7aba425"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "954714b47744162cd625786206881bad5e316b1fdc039cb2f4bf9fb610c06044"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e067cef3ecf9c3128a5dc98d99120574fa86cd71847db5bb0ae009efc58658ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e3249b9de8259e3df769d013fa1809c49abc4d602c7db81ad68cb9c0197fa09"
    sha256 cellar: :any_skip_relocation, ventura:        "40ff6039e06bfd8df14f0056ef5b03c64c618198aad79ec6558bfd548dae924a"
    sha256 cellar: :any_skip_relocation, monterey:       "6b909bbfffa891bbf1303d18adb09e4720220111e8aaa10e6a8cb192a2b96f66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8f9968d2957c0ff98e97b171388f8decb94b9deeebbe982639c151d539c4e84"
  end

  # Can change this to 21 in later releases.
  depends_on "openjdk@17" => :build

  uses_from_macos "zlib"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@17"].opt_prefix
    # Need to set this so that native-image passes through env vars when calling out to the C toolchain.
    ENV["NATIVE_IMAGE_DEPRECATED_BUILDER_SANITATION"] = "true"

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
