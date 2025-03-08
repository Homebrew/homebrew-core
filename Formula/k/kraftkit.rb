class Kraftkit < Formula
  desc "Build and use highly customized and ultra-lightweight unikernel VMs"
  homepage "https://unikraft.org/docs/cli"
  url "https://github.com/unikraft/kraftkit/archive/refs/tags/v0.11.4.tar.gz"
  sha256 "c92c0f3867502d7fd770c0cf71f291c0c32a25fbb5f55459af8983d1f7e2edf4"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5d6c3e1dbde855f27773135a896d0a7c5356fb6d2e61775b6de6eee8ac26af15"
    sha256 cellar: :any,                 arm64_sonoma:  "a059754dbdc653c1770dbb49d18aa1146114ea0a81a4aef6259a547118f8740d"
    sha256 cellar: :any,                 arm64_ventura: "3272c5c6357a2ee08759b9f80119495bbe812c77311387ca6c7782528e1ac590"
    sha256 cellar: :any,                 sonoma:        "fe4a8279909e6b5237866a4417d9bd66332a599bc323f8d66103a8852802ed6c"
    sha256 cellar: :any,                 ventura:       "09dae79d16fe989b6826ae14244644f077bdc6cc0a9c995f2c682c1512b5cd2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b0914dfa067d255cbbe3a23106ca79741a9c8a52cad3922e0d37393777c0822"
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
