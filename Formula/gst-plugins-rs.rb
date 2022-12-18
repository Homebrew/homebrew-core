class GstPluginsRs < Formula
  desc "GStreamer plugins written in Rust"
  homepage "https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs"
  url "https://gitlab.freedesktop.org/gstreamer/gst-plugins-rs/-/archive/0.9.3/gst-plugins-rs-0.9.3.tar.bz2"
  sha256 "2d3fb004f8004f347f86adbef7a3aa870a5b1bd300c5410f53685daefb8d1e8c"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "919fe1d643d32b727d5f074f64be8fead7c8938bda439b4195438e442eb56633"
    sha256 cellar: :any,                 arm64_monterey: "63dae8a153e2bdbd5df4aefcd3b9f0284193ff6c445622fa6856e576b81e124b"
    sha256 cellar: :any,                 arm64_big_sur:  "a4c0725297a1aa516636d8dec7c575a88c77845cff2fd79c580675dfe93b1bca"
    sha256 cellar: :any,                 ventura:        "9c5a9261259d62b6038edefd4c3142c81f272ca3d8939dd186dafd470d0a809f"
    sha256 cellar: :any,                 monterey:       "4b5f251c5bf0f1f48eb842560401ba33d0abec017a6011c75457e5a732484204"
    sha256 cellar: :any,                 big_sur:        "15033557efa198a8dcd8fc1e3ececa06be5a39324a6138ff309678df2122bc03"
    sha256 cellar: :any,                 catalina:       "d62686f1996af06e4302a5f9dd7f4d12c5d834aa7724ed1ffddddf357cd1af93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36987244d8cddf346769d29128e7172250d3faf909e75c35add9f09312d1d778"
  end

  depends_on "cargo-c" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.11" => :build # needs python with tomllib
  depends_on "rust" => :build
  depends_on "dav1d"
  depends_on "gst-plugins-bad" # for webrtc
  depends_on "gst-plugins-base"
  depends_on "gstreamer"
  depends_on "gtk4"
  depends_on "pango" # for closedcaption

  # Fix building `libwebp-sys2` crate on Intel macOS (SSE4.1 support).
  # The resource version matches version picked by Cargo dependency resolution.
  # We use git URL rather than generated source tarball to get submodule.
  # The crate could also be used, but it requires manual extraction as brew
  # cannot handle .crate extension and this means we cannot use patch DSL.
  # TODO: Remove when upstream PR is approved and available in release.
  on_macos do
    on_intel do
      resource "libwebp-sys2" do
        url "https://github.com/qnighy/libwebp-sys2-rs.git",
            tag:      "v0.1.4",
            revision: "3ecdb2e4898820d46436a76e1cfee75ec14a881a"

        # PR ref: https://github.com/qnighy/libwebp-sys2-rs/pull/13
        patch do
          url "https://github.com/qnighy/libwebp-sys2-rs/commit/eddb6e2d1ef88b1b1a68d7709733e7dff81f6659.patch?full_index=1"
          sha256 "0bee66cf8e29880719c64d54be0e8199da91c8d4aa9fce13e26b0cc024371e4d"
        end
      end
    end
  end

  on_linux do
    depends_on "pkg-config" => :build
    # TODO: Use `webp` dependency on macOS when supported.
    # Issue ref: https://github.com/qnighy/libwebp-sys2-rs/issues/4
    depends_on "webp"
  end

  def install
    if OS.mac? && Hardware::CPU.intel?
      (buildpath/"libwebp-sys2").install resource("libwebp-sys2")
      inreplace "video/webp/Cargo.toml", "libwebp-sys2 = {", "\\0 path = \"#{buildpath}/libwebp-sys2\","
    end

    # Fixes an issue where the wrong Python is picked up in the Linux build
    ENV.prepend_path "PATH", Formula["python@3.11"].libexec/"bin"

    mkdir "build" do
      # csound is disabled as the dependency detection seems to fail
      # the sodium crate fails while building native code as well
      args = std_meson_args + %w[
        -Dclosedcaption=enabled
        -Ddav1d=enabled
        -Dsodium=disabled
        -Dcsound=disabled
        -Dgtk4=enabled
      ]
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    gst = Formula["gstreamer"].opt_bin/"gst-inspect-1.0"
    output = shell_output("#{gst} --plugin rsfile")
    assert_match version.to_s, output
  end
end
