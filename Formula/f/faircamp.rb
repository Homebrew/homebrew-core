class Faircamp < Formula
  desc "Static site generator for audio producers"
  homepage "https://codeberg.org/simonrepp/faircamp"
  url "https://codeberg.org/simonrepp/faircamp/archive/0.13.0.tar.gz"
  sha256 "e49469b6706ce607e1f0f83db4db1e102528a5b9f8a1111c4b503d7d727e74f0"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "8e889e61386ae16e9e4e7554b67f10bb9e825e16e24aa2f34d860151190b7f13"
    sha256 cellar: :any, arm64_ventura:  "64d9ea8e938980213d224320bb3b68296beb68021dce5f99df1ca2faee4e31d1"
    sha256 cellar: :any, arm64_monterey: "899d6462ed0be1f8156c5da3cf7b93362a616d650eb36ff6b2e6fa1201daa8b7"
    sha256 cellar: :any, sonoma:         "18b1c53bad1f6d920b9d2301045bb7215e1d13184a1c10f8eebc99a51de08bdf"
    sha256 cellar: :any, ventura:        "ff370093b09e14ffe56fc4fe1b5b7e9df88c1bb7c9944705616b83c48318beb5"
    sha256 cellar: :any, monterey:       "36f46ee163c5943fe324690390fb3a79a16d7b8a7032aeee4d9bbf3d6d69d71c"
  end

  depends_on "opus" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"
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
