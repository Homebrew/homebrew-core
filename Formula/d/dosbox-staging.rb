class DosboxStaging < Formula
  desc "Modernized DOSBox soft-fork"
  homepage "https://dosbox-staging.github.io/"
  url "https://github.com/dosbox-staging/dosbox-staging/archive/refs/tags/v0.83.0.tar.gz"
  sha256 "9b36be5a666784adaeffa560bd0950691f851a76bdb97e7ae3c989561e91caf3"
  license "GPL-2.0-or-later"
  head "https://github.com/dosbox-staging/dosbox-staging.git", branch: "main"

  # New releases of dosbox-staging are indicated by a GitHub release (and
  # an announcement on the homepage), not just a new version tag.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256               arm64_golden_gate: "631f8f9b0a0713795b5b103442a30e21345469aed7b94a0f22ec7f45c642baa4"
    sha256               arm64_tahoe:       "6eefc723f61cee95d76f834671fc674b9207d52791b16305ed2afe476d9e7e8a"
    sha256               arm64_sequoia:     "bdfb33287fcd9b8e8ebd12641bfe10dc23928ad12f5c279de9f4539bdfb25869"
    sha256               arm64_sonoma:      "ab66fbed8d0d032bbbc26784ed75ef16ce57c38fef36b908439527c674f1f896"
    sha256               arm64_linux:       "db4c8c85ba32af9c14da0e700a913e5d45b34968fd881e763eda3878d25e1067"
    sha256 cellar: :any, x86_64_linux:      "f897b12d7b9f6b831476ccb8a1ba7fcf82ee08ecbe4232b424051caf28b33955"
  end

  depends_on "asio" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "fluid-synth"
  depends_on "iir1"
  depends_on "libpng"
  depends_on "libslirp"
  depends_on "mt32emu"
  depends_on "opusfile"
  depends_on "sdl2-compat"
  depends_on "sdl2_image"
  depends_on "speexdsp"
  depends_on "zlib-ng"

  on_linux do
    depends_on "alsa-lib"
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "zlib-ng-compat"
  end

  # Fix system library builds and installation, upstream PR ref, https://github.com/dosbox-staging/dosbox-staging/pull/5046
  patch do
    url "https://github.com/dosbox-staging/dosbox-staging/commit/e97e927c198960c809d18fae53280554ed0c975f.patch?full_index=1"
    sha256 "838fe6ea1ba409d33b3301d5f53b9a8c80893e3754c208f4d62e689035228891"
    type :unofficial
  end

  deny_network_access! :test

  def install
    # Slirp is loaded at runtime instead of linked by CMake.
    inreplace "src/network/ethernet_slirp.cpp", '"libslirp.', %Q("#{formula_opt_lib("libslirp")}/libslirp.)

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    "-DOPT_TESTS=OFF", "-DUSE_SYSTEM_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"

    if OS.mac?
      bin.install "build/dosbox" => "dosbox-staging"
      man1.install "docs/dosbox.1" => "dosbox-staging.1"
      pkgshare.install Dir["build/Resources/*"]
    else
      system "cmake", "--install", "build"
      mv bin/"dosbox", bin/"dosbox-staging"
      mv man1/"dosbox.1", man1/"dosbox-staging.1"
    end
  end

  test do
    config_path = OS.mac? ? "Library/Preferences/DOSBox" : ".config/dosbox"
    mkdir testpath/config_path
    touch testpath/config_path/"dosbox-staging.conf"

    assert_match "crt/crt-hyllian", shell_output("#{bin}/dosbox-staging --list-shaders")
    assert_match version.to_s, shell_output("#{bin}/dosbox-staging -version")
    output = shell_output("#{bin}/dosbox-staging -printconf")
    assert_equal testpath/config_path/"dosbox-staging.conf", Pathname(output.chomp)
  end
end
