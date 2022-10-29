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
    sha256 cellar: :any_skip_relocation, all: "00e2c051efd2fbb588d34d1b96d1582252ccf0c3a254d4f994d81b6a7fe3fea8"
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
