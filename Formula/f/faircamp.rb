class Faircamp < Formula
  desc "Static site generator for audio producers"
  homepage "https://codeberg.org/simonrepp/faircamp"
  url "https://codeberg.org/simonrepp/faircamp/archive/2.0.2.tar.gz"
  sha256 "97046d78d8c09837067ae9290fe7aecf5dbb3eb107c1346583534fcb715349f0"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "16892d7219ae5f72d9a2f32aa957fdb041c507d4649e0726861e344b229cddf2"
    sha256 cellar: :any, arm64_tahoe:       "49796ca668155037379281121360d4f651d00ec7b1b33f3d0c07ce5f119d796c"
    sha256 cellar: :any, arm64_sequoia:     "09da44239757e2d198a941cf217bc4acebca8d61ddc18ceb3a138d7557fd4d1c"
    sha256 cellar: :any, arm64_linux:       "af6a518df42a8002848759851fd6bcd759645bf51f62b617734204b75d87263b"
    sha256 cellar: :any, x86_64_linux:      "8773bc2008a0e65fb224749dfa61d2bf731b9d1a4c126abf56c91588fca2f171"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"
  depends_on "opus"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # `audiopus_sys` links opus statically on macOS by default
    ENV.append_to_rustflags Utils.safe_popen_read("pkgconf", "--libs", "opus").chomp

    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/faircamp-cli --version")

    site_dir = testpath/"site"
    release_dir = site_dir/"release"
    release_dir.mkpath
    cp test_fixtures("test.wav"), release_dir/"track.wav"
    cp test_fixtures("test.jpg"), release_dir/"cover.jpg"

    build_dir = testpath/"build"
    system bin/"faircamp-cli", "build", "--site-dir", site_dir, "--build-dir", build_dir
    assert_path_exists build_dir/"index.html"
    assert_path_exists build_dir/"favicon.svg"
  end
end
