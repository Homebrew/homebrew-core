class Kraftkit < Formula
  desc "Build and use highly customized and ultra-lightweight unikernel VMs"
  homepage "https://unikraft.org/docs/cli"
  url "https://github.com/unikraft/kraftkit/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "97ef3f7fc3d667ad1a9e6af5a55fa20b89848d2f690e76501c75a0ec0669deea"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5d65e311ea4b88d2428058141cc91ac1455a9b5e3bfc16c5edb81a305cabe2b1"
    sha256 cellar: :any,                 arm64_sonoma:  "1b2bf1a39e65cbe13e12ad121b5c4c57d570ee879d4059a27339ffbae3c9b7fe"
    sha256 cellar: :any,                 arm64_ventura: "9ba25ba22a2f71d7f02bcaf685f81f2b1899a0c7c8d386ef6209d8fc5520e814"
    sha256 cellar: :any,                 sonoma:        "3da0420fd762f2faf125f29611ec98c519f4acfa101d178abf09e84e5bb5417e"
    sha256 cellar: :any,                 ventura:       "340ad97eb014d0a7a32a083009081dbd07daa9b081af3df9a7d1cb9b5e27602a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcad62e6101708a27284ad3adebab5a185cfaf8b20f1e70625a71b70a6d2ddf5"
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
