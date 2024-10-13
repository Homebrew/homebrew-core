class Faircamp < Formula
  desc "Static site generator for audio producers"
  homepage "https://codeberg.org/simonrepp/faircamp"
  url "https://codeberg.org/simonrepp/faircamp/archive/0.17.0.tar.gz"
  sha256 "026d4a0dcb16f0db145a100b97bfc52f1544ce632c42a198517ab3fbdb89d029"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "06580cb9b3d343e110622a93914e4f2a8c9d47b22ccf6966d46f7585e94489bd"
    sha256 cellar: :any, arm64_sonoma:  "fa1d0e656307b20379bc97afb07349f68b43ae72a9a1e79235555033cb9d8f49"
    sha256 cellar: :any, arm64_ventura: "954335417008aaf18224faad47f18e47c8fb4f30a7f16d623d78d8f11f328c17"
    sha256 cellar: :any, sonoma:        "72950863ec090ab26aab6ae2f918ae37544d1aede33b84e94565517fa1306a04"
    sha256 cellar: :any, ventura:       "59e99923ca047386bfcf73526fa639da3d2bffa8bd7124ecde663d25ffed9972"
  end

  depends_on "opus" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"
  depends_on "gettext"
  depends_on "glib"
  # Brew's libopus behaves differently in linux compared to macOS and
  # results in runtime errors. Further investigation and work on this
  # formulae is needed to support linux builds. The upstream project
  # provides their own mechanism for linux distribution. Brew is most
  # valuable on macOS, where there is no other suitable package manager,
  # so for now, restrict this formulae to macOS.
  depends_on :macos
  depends_on "vips"

  def install
    # libvips is a runtime dependency, the brew install location is
    # not discovered by default by Cargo. Upstream issue:
    #   https://codeberg.org/simonrepp/faircamp/issues/45
    ENV["RUSTFLAGS"] = `pkg-config --libs vips`.chomp
    system "cargo", "install", *std_cargo_args, "--features", "libvips"
  end

  test do
    # Check properly compiled with optional libvips feature
    version_str = shell_output("#{bin}/faircamp --version").chomp
    assert_match "faircamp #{version} (compiled with libvips)", version_str

    # Check site generation
    catalog_dir = testpath/"Catalog"
    album_dir = catalog_dir/"Artist"/"Album"
    mkdir_p album_dir
    cp test_fixtures("test.wav"), album_dir/"Track01.wav"
    cp test_fixtures("test.wav"), album_dir/"Track02.wav"
    cp test_fixtures("test.jpg"), album_dir/"artwork.jpg"

    output_dir = testpath/"html"
    system bin/"faircamp", "--catalog-dir", catalog_dir, "--build-dir", output_dir

    assert_path_exists output_dir/"favicon.svg"
    assert_path_exists output_dir/"album"/"index.html"
    assert_path_exists output_dir/"album"/"cover_1.jpg"
    assert_path_exists output_dir/"album"/"opus-96"/"ASINtk0hKII"/"01 Track01.opus"
    assert_path_exists output_dir/"album"/"opus-96"/"uWPoxZFX0kQ"/"02 Track02.opus"
    assert_path_exists output_dir/"album"/"mp3-v5"/"1syLQAjRlm8"/"01 Track01.mp3"
    assert_path_exists output_dir/"album"/"mp3-v5"/"zh4GTzy3VT0"/"02 Track02.mp3"
  end
end
