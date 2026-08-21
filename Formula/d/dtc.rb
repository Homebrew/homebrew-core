class Dtc < Formula
  desc "Device tree compiler"
  homepage "https://git.kernel.org/pub/scm/utils/dtc/dtc.git"
  url "https://mirrors.edge.kernel.org/pub/software/utils/dtc/dtc-1.8.1.tar.xz"
  sha256 "23526015a6f1550e0541a53fe7acea1b5a11e3697cdf3a3bdc076abc38f6045d"
  license any_of: ["GPL-2.0-or-later", "BSD-2-Clause"]
  compatibility_version 1
  head "https://git.kernel.org/pub/scm/utils/dtc/dtc.git", branch: "master"

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/software/utils/dtc/"
    regex(/href=.*?dtc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c85117d5237ea464866d8712ff9fc264a1701eca34d9d470d720a935c79f61ba"
    sha256 cellar: :any, arm64_sequoia: "2b800aed01f5ebfc9cbb685536ad1625d1d702ab850bd34639865d3457c4f2e8"
    sha256 cellar: :any, arm64_sonoma:  "5096223d06fe3abcc5d668b1dbc86c8f9b3b96d96c382afb16dfa580000b3379"
    sha256 cellar: :any, sonoma:        "12e87f7f007759ce7137f039520358afeb48aae1d8f52c4a4bfe5f1acfb4f31c"
    sha256               arm64_linux:   "45cf765efbad445c3dbd17ec9caa151a4a0908ba451c0bebbbe19b56e792508e"
    sha256               x86_64_linux:  "0829b345a6d8fe1529a5676dc569fc5f445085ddf3b20863c787c596f650c358"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "libyaml"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    args = %w[
      -Dpython=disabled
      -Dtests=false
      -Dvalgrind=disabled
      -Dwerror=false
      -Dyaml=enabled
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.dts").write <<~EOS
      /dts-v1/;
      / {
      };
    EOS
    system bin/"dtc", "test.dts"
  end
end
