class Kraftkit < Formula
  desc "Build and use highly customized and ultra-lightweight unikernel VMs"
  homepage "https://unikraft.org/docs/cli"
  url "https://github.com/unikraft/kraftkit/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "919b86d44232ca443dee7b7be547fa6983036ac9dd3c11a0b744c1a6799af550"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4da02f2e9a16724401ad3aaa71f9e708d8e69319dd682d5f096a93e525ab4eb9"
    sha256 cellar: :any,                 arm64_sonoma:  "6520f5ae2b5e50d04040d6ad9a5e6b2d22c5f269041fdd408406553d038d4aa5"
    sha256 cellar: :any,                 arm64_ventura: "3f24227a64581cfe3f110b1afeb826a5fafccc855ad820ee833234b1f19ccd1c"
    sha256 cellar: :any,                 sonoma:        "14c3ce340f523ad930c525327dd4bd5be5dacce84bc82d42e20bcc290e05ee48"
    sha256 cellar: :any,                 ventura:       "7f363ca81b228a4ae090442faa92e1fbb9d687b6ad5515a8e5d5129c0a2c5b15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4fb912b888a4b6015e995e55aeb0e43c4e67b2345238b068295f17cae331902"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "btrfs-progs"
  end

  def install
    ldflags = %W[
      -s -w
      -X kraftkit.sh/internal/version.version=#{version}
      -X kraftkit.sh/internal/version.commit=#{tap.user}
      -X kraftkit.sh/internal/version.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"kraft"), "./cmd/kraft"

    generate_completions_from_executable(bin/"kraft", "completion")
  end

  test do
    expected = if OS.mac?
      "could not determine hypervisor and system mode"
    else
      "found unikraft.org/helloworld:latest (qemu/x86_64)"
    end
    assert_match expected, shell_output("#{bin}/kraft run unikraft.org/helloworld:latest 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/kraft version")
  end
end
