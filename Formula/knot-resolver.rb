class KnotResolver < Formula
  desc "Minimalistic, caching, DNSSEC-validating DNS resolver"
  homepage "https://www.knot-resolver.cz"
  url "https://secure.nic.cz/files/knot-resolver/knot-resolver-5.5.3.tar.xz"
  sha256 "a38f57c68b7d237d662784d8406e6098aad66a148f44dcf498d1e9664c5fed2d"
  license all_of: ["CC0-1.0", "GPL-3.0-or-later", "LGPL-2.1-or-later", "MIT"]
  head "https://gitlab.labs.nic.cz/knot/knot-resolver.git", branch: "master"

  livecheck do
    url "https://secure.nic.cz/files/knot-resolver/"
    regex(/href=.*?knot-resolver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "26c0cc619db0701c66d8264595ef1b4b4f341cc53e5b91a09bba810823e18aec"
    sha256 arm64_big_sur:  "dc130750c64885bdfec3c33c66d75547fa05c350e0023851c26e1f8816345fbb"
    sha256 monterey:       "3a0e4737a28bd51e236b800161282b4f315a4a7df34ed3571c69b811acc808d1"
    sha256 big_sur:        "a5228303c870b7b95e3f075843d504b6373990fbfaa88306becbf8363bc815fa"
    sha256 catalina:       "514c0c14b066f6e6698afbc917ce9a123a7e8473f8de688bafe46b93d8044b17"
    sha256 x86_64_linux:   "9dc0d26e0408e5b913d39b659810e0a59895be8f5c3eae5725b28735e1984b0f"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "knot"
  depends_on "libnghttp2"
  depends_on "libuv"
  depends_on "lmdb"
  depends_on "luajit-openresty"

  on_linux do
    depends_on "libcap-ng"
    depends_on "systemd"
  end

  def install
    args = std_meson_args + ["--default-library=static"]
    args << "-Dsystemd_files=enabled" if OS.linux?

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  def post_install
    (var/"knot-resolver").mkpath
  end

  plist_options startup: true
  service do
    run [opt_sbin/"kresd", "-c", etc/"knot-resolver/kresd.conf", "-n"]
    working_dir var/"knot-resolver"
    input_path "/dev/null"
    log_path "/dev/null"
    error_log_path var/"log/knot-resolver.log"
  end

  test do
    assert_path_exists var/"knot-resolver"
    system sbin/"kresd", "--version"
  end
end
