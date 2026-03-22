class Apptainer < Formula
  desc "Application container and unprivileged sandbox platform for Linux"
  homepage "https://apptainer.org/"
  url "https://github.com/apptainer/apptainer/releases/download/v1.4.5/apptainer-1.4.5.tar.gz"
  sha256 "d323a8b9a0a9e5e131b396d0049fdaa99beceb83a3d7ffb80dd91d15331e3b9a"
  license "BSD-3-Clause"
  head "https://github.com/apptainer/apptainer.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_linux:  "869d04ad3305e8a4f7129c6cd978ec4d48972b049c65edfbb56d3c6048714df6"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c0e1729e484d95e8c33083e9fa81046d60d4dc2ebae1c1ea195c4009158c7124"
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
      -P release-stripped
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
