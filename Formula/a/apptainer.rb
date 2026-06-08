class Apptainer < Formula
  desc "Application container and unprivileged sandbox platform for Linux"
  homepage "https://apptainer.org/"
  url "https://github.com/apptainer/apptainer/releases/download/v1.5.1/apptainer-1.5.1.tar.gz"
  sha256 "ae00a6a2f1949a8f245c082660fd2990d61a6543159c9a28eede7966d89efe62"
  license "BSD-3-Clause"
  head "https://github.com/apptainer/apptainer.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_linux:  "10579022b0544f6da8a32af1eb69c5a55c5b2936348bab496e16b478161f6ba4"
    sha256 cellar: :any, x86_64_linux: "2b784cb5a5354a5f3fe422c62094cf964004ffc47dd38308d8a7660367320001"
  end

  # No relocation, the localstatedir to find configs etc is compiled into the program
  pour_bottle? only_if: :default_prefix

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "libseccomp"
  depends_on :linux
  depends_on "squashfs"

  def install
    ENV["CGO_ENABLED"] = "1" if Hardware::CPU.arm?

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --without-suid
      -P release
      -v
    ]
    ENV.O0
    system "./mconfig", *args
    cd "./builddir" do
      system "make"
      system "make", "install"
    end

    generate_completions_from_executable(bin/"apptainer", shell_parameter_format: :cobra)
  end

  test do
    assert_match(/There are [0-9]+ container file/, shell_output("#{bin}/apptainer cache list"))
    # This does not work inside older github runners, but for a simple quick check, run:
    # singularity exec library://alpine cat /etc/alpine-release
  end
end
