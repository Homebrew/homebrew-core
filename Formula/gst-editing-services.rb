class GstEditingServices < Formula
  desc "GStreamer Editing Services"
  homepage "https://gstreamer.freedesktop.org/modules/gst-editing-services.html"
  url "https://gstreamer.freedesktop.org/src/gst-editing-services/gst-editing-services-1.20.2.tar.xz"
  sha256 "2ddef442cf8313e78477510a4461c8522f180afef26d035a38fea3f5006d012f"
  license "LGPL-2.0-or-later"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-editing-services/"
    regex(/href=.*?gst(?:reamer)?-editing-services[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "f835dfd475d4f014c927e06f232eac88fb82a3aa8790d6f695ccc013aa332f24"
    sha256 cellar: :any, arm64_big_sur:  "f864af216b70b6b83d51fe0139e42e25f6c78338d85f80e701debc1f7927d8da"
    sha256 cellar: :any, monterey:       "90cc39a61be23b30e6284497bb9d218aa44e2f211a272a3859b15dc0853d53e9"
    sha256 cellar: :any, big_sur:        "18d4c81c3980bd1d8cc2bf87a3108c544ecdd7f40a77233cafb44b9c91461bc9"
    sha256 cellar: :any, catalina:       "94240503d99b2413e169cb0adbbb3a8f8886bc9c1bd394bd84133133ec8b9ea0"
    sha256               x86_64_linux:   "1309865dfea44b887ec1a1e5937f7811688ba2b63a5aedb1caa1551bff164bd6"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gst-plugins-base"
  depends_on "gstreamer"

  uses_from_macos "flex" => :build

  on_linux do
    depends_on "json-glib"
  end

  def install
    args = std_meson_args + %w[
      -Dintrospection=enabled
      -Dtests=disabled
      -Dvalidate=disabled
    ]
    # https://gitlab.freedesktop.org/gstreamer/gst-editing-services/-/issues/114
    # https://github.com/Homebrew/homebrew-core/pull/84906
    args << "-Dpython=disabled"

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    system "#{bin}/ges-launch-1.0", "--ges-version"
  end
end
