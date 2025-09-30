class Kraftkit < Formula
  desc "Build and use highly customized and ultra-lightweight unikernel VMs"
  homepage "https://unikraft.org/docs/cli"
  url "https://github.com/unikraft/kraftkit/archive/refs/tags/v0.11.6.tar.gz"
  sha256 "7a0cd9b656c34ec801c8bef6716787292f7ab8eada15f6919002e2db267b0801"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/unikraft/kraftkit.git", branch: "staging"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "168d1c9d8eefc670572499de24ff8ae9916d44b2d805b32e116f27c063610195"
    sha256 cellar: :any,                 arm64_sequoia: "92dd7cf9b0a6ad13250d0e7336f05618a251b117d7506697f3b28e86a1b6d342"
    sha256 cellar: :any,                 arm64_sonoma:  "0b3ee8d9088d401fc36b4aaa578c0c5bccf58063c309cc71b2c31244fce53868"
    sha256 cellar: :any,                 arm64_ventura: "8812421ccc67f74a2530388fd2b3f4f8d8b50567862dbe016423ce36139231eb"
    sha256 cellar: :any,                 sonoma:        "95dd5605349986b2cf50fceef06a4dac9fca433ac9a066e0364449c330d4dbc6"
    sha256 cellar: :any,                 ventura:       "9c7c5d7d86b5c86e7f1353bbbe40e9681e14576b5dd98ce4539a02791828d8d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72f75b1f3d8010b0773726003c9ad4edd7fcceffe7658cf6d01e0174ba1eb20a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "641a7982b36f6580ebe2e238d5c7b92d2bf9c50da5e17363f07e2c4b64abbc56"
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
      "finding unikraft.org/helloworld:latest"
    end
    assert_match expected, shell_output("#{bin}/kraft run unikraft.org/helloworld:latest 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/kraft version")
  end
end
