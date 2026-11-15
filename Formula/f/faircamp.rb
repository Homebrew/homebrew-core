class Faircamp < Formula
  desc "Static site generator for audio producers"
  homepage "https://codeberg.org/simonrepp/faircamp"
  url "https://codeberg.org/simonrepp/faircamp/archive/2.0.2.tar.gz"
  sha256 "97046d78d8c09837067ae9290fe7aecf5dbb3eb107c1346583534fcb715349f0"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a76e8bf8a3b41adccc3ccf30ee0dd3f4a52f323e1b7e3cf08ba4e3909e1a3867"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "92fa031f292f81c056843698482ea657f46036a47ef7bffc97d2e9d412db8799"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "afedfdaa940e2fb17ff1ed029fc227eb2e78b88bd132514c0993f89a90d7b967"
    sha256 cellar: :any,                 arm64_linux:       "7a83de08184eaa19fef65d48485786f606647b158f04a8bbb3c34bb67fac37f9"
    sha256 cellar: :any,                 x86_64_linux:      "980542e5ea663a4e895886a95b7ccfbc3d20589eb589a8f846c6f45af3eb2b29"
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
