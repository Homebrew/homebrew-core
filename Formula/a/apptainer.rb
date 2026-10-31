class Apptainer < Formula
  desc "Application container and unprivileged sandbox platform for Linux"
  homepage "https://apptainer.org/"
  license "BSD-3-Clause"
  head "https://github.com/apptainer/apptainer.git", branch: "main"

  stable do
    url "https://github.com/apptainer/apptainer/releases/download/v1.5.5/apptainer-1.5.5.tar.gz"
    sha256 "d61347c9e554954ae662f40077a163d2af6422e65bbd254797606a8a36cf31c6"

    # Fix build compatibility with Go 1.27.
    patch do
      file "Patches/apptainer/go-1.27.diff"
      type :backport
      resolves "https://github.com/apptainer/apptainer/pull/3563"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_linux:  "6f2b5c7119ab40712dec2149d33646a79f9f51b7709b83951c0af2f5068fc43c"
    sha256 cellar: :any, x86_64_linux: "b689135e50e3ddae1ef82575396728b723aab9b13a17516d0a8a2cad5380ac4f"
  end

  # No relocation, the localstatedir to find configs etc is compiled into the program
  pour_bottle? only_if: :default_prefix

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "libseccomp"
  depends_on :linux
  depends_on "squashfs"

  deny_network_access!

  def fetch
    system "go", "mod", "vendor"
  end

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
