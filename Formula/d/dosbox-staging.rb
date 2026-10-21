class DosboxStaging < Formula
  desc "Modernized DOSBox soft-fork"
  homepage "https://dosbox-staging.github.io/"
  license "GPL-2.0-or-later"

  stable do
    url "https://github.com/dosbox-staging/dosbox-staging/archive/refs/tags/v0.83.0.tar.gz"
    sha256 "9b36be5a666784adaeffa560bd0950691f851a76bdb97e7ae3c989561e91caf3"

    depends_on "sdl2-compat"
    depends_on "sdl2_image"

    # Fix system library builds and installation, upstream PR ref, https://github.com/dosbox-staging/dosbox-staging/pull/5046
    patch do
      url "https://github.com/dosbox-staging/dosbox-staging/commit/e97e927c198960c809d18fae53280554ed0c975f.patch?full_index=1"
      sha256 "838fe6ea1ba409d33b3301d5f53b9a8c80893e3754c208f4d62e689035228891"
      type :unofficial
    end

    # Backport handling of zlib dependency
    patch do
      url "https://github.com/dosbox-staging/dosbox-staging/commit/d12e88ced5ae5b94c48bde4c2809b53da6f6ecae.patch?full_index=1"
      sha256 "aecb0c7cc96de7acb862bd3b850ecbf79b5bb5dd379012586eb68f8f3495f457"
      type :backport
    end
    patch do
      url "https://github.com/dosbox-staging/dosbox-staging/commit/482477a6f48ba30520920c0a09732371ba1cd772.patch?full_index=1"
      sha256 "219438a2110b49f0a9b62e0e547c35db7cdce3f7fa40feb5d529529fe07fe5bb"
      type :backport
    end
  end

  # New releases of dosbox-staging are indicated by a GitHub release (and
  # an announcement on the homepage), not just a new version tag.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256               arm64_golden_gate: "2bf1cf1ffac1ac74860404bd384a5fbdd4ea5e83c27c1324aa9fdce8e9c805d7"
    sha256               arm64_tahoe:       "e3abf6810ce748014c281388af63c0fa24a6ce494ec67e0f752054563245b04e"
    sha256               arm64_sequoia:     "c466cd01624d5b416a0205783c8d5c50d8ffcc93501ff8a5e5a397ded8c42d8b"
    sha256               arm64_linux:       "38271f126184b3824f19574085623128b8081eb4f3383e4ab3fc6d29d88c7906"
    sha256 cellar: :any, x86_64_linux:      "d38d15d8d2ee472b83bb102b9c813f8ca37cdcad8726e40f37db44a2683ba77a"
  end

  head do
    url "https://github.com/dosbox-staging/dosbox-staging.git", branch: "main"

    depends_on "sdl3"
    depends_on "sdl3_image"
  end

  depends_on "asio" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "fluid-synth"
  depends_on "iir1"
  depends_on "libpng"
  depends_on "libslirp" => :no_linkage
  depends_on "mt32emu"
  depends_on "opusfile"
  depends_on "speexdsp"

  on_linux do
    depends_on "alsa-lib"
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "zlib-ng-compat"
  end

  deny_network_access! :test

  def install
    args = %w[
      -DOPT_TESTS=OFF
      -DUSE_SYSTEM_LIBS=ON
    ]
    # Slirp is loaded at runtime instead of linked by CMake
    libslirp_rpath = rpath(target: formula_opt_lib("libslirp"))
    args << "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{libslirp_rpath} -Wl,-undefined,dynamic_lookup" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"

    if OS.mac?
      bin.install "build/dosbox"
      man1.install "docs/dosbox.1"
      pkgshare.install Dir["build/Resources/*"]
    else
      system "cmake", "--install", "build"
    end
    bin.install_symlink "dosbox" => "dosbox-staging"
    man1.install_symlink "dosbox.1" => "dosbox-staging.1"
  end

  test do
    config_path = OS.mac? ? "Library/Preferences/DOSBox" : ".config/dosbox"
    mkdir testpath/config_path
    touch testpath/config_path/"dosbox-staging.conf"

    assert_match "crt/crt-hyllian", shell_output("#{bin}/dosbox --list-shaders")
    assert_match version.to_s, shell_output("#{bin}/dosbox -version")
    output = shell_output("#{bin}/dosbox -printconf")
    assert_equal testpath/config_path/"dosbox-staging.conf", Pathname(output.chomp)
  end
end
