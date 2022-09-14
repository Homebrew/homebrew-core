class Lv2 < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Portable plugin standard for audio systems"
  homepage "https://lv2plug.in/"
  url "https://lv2plug.in/spec/lv2-1.18.10.tar.xz"
  sha256 "78c51bcf21b54e58bb6329accbb4dae03b2ed79b520f9a01e734bd9de530953f"
  license any_of: ["0BSD", "ISC"]
  head "https://gitlab.com/lv2/lv2.git", branch: "master"

  livecheck do
    url "https://lv2plug.in/spec/"
    regex(/href=.*?lv2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7dc724579ab092ba23410032938c62efecfbf60621a7b3cbff21aaa42f882215"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "daa87f384b7273e4427129ceac5ad31c907bcb622fd2f5db62bdcd6cdc3eb1f8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed23068fd5e5a95776bbf324ea617c55047d7318572afb5c1a1e755ac00c1415"
    sha256 cellar: :any_skip_relocation, monterey:       "b67b0e37486e087da361df78f53848ea6058ac70015fa85c4560b3dc4d33d532"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4b428f002f2f9c28f74f98c5009dd5f5da351c26499b5721ec60927a2ad7979"
    sha256 cellar: :any_skip_relocation, catalina:       "a7a7509601ab20a9115cd3117b8c577e3fc0a155f632950609f1ac21f0e24dbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7b0ba1633dd9a21b03f682406f60814218806fd23f68a89abee5f2200b80b25"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.10"

  def install
    system "meson", "build", *std_meson_args, "-Dplugins=disabled", "-Dlv2dir=#{lib}/lv2"
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"

    (pkgshare/"example").install "plugins/eg-amp.lv2/amp.c"
  end

  test do
    # Try building a simple lv2 plugin
    dynamic_flag = OS.mac? ? "-dynamiclib" : "-shared"
    system ENV.cc, pkgshare/"example/amp.c", "-I#{include}",
           "-DEG_AMP_LV2_VERSION=1.0.0", "-DHAVE_LV2=1", "-fPIC", dynamic_flag,
           "-o", shared_library("amp")
  end
end
