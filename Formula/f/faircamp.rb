class Faircamp < Formula
  desc "Static site generator for audio producers"
  homepage "https://codeberg.org/simonrepp/faircamp"
  url "https://codeberg.org/simonrepp/faircamp/archive/1.7.0.tar.gz"
  sha256 "599429eeef873fbe68e3f7b0cf15901d08e2819e9034ea5db2e06bc235fa3559"
  license "AGPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "66169557403a27f0ba6f4e2ad043108b69dbbd813ae9b523e5bdd70bd4198ed8"
    sha256 cellar: :any, arm64_sequoia: "8b4ba92f1a565e98368cda5f60b3c47b778197bbe497913bdd7e90b342cb321a"
    sha256 cellar: :any, arm64_sonoma:  "c47ae0184f72f2a2a3fc2a99b2ab0a3c3a0759608e6909d190deebdd32b5737e"
    sha256 cellar: :any, sonoma:        "b62e91623bd651cf0f6a3fe9cc3bd923ade96c471fb7d4de00407ed273ca3446"
    sha256 cellar: :any, arm64_linux:   "0a8d16c9c10d85bbd9d1eb169236c3e2b59966f23e02da9fd1cf1dd09676ac8f"
    sha256 cellar: :any, x86_64_linux:  "f7dfe751e1b76008a6af1545cf2ad181bc48c72f26de4242e687e2af90634f32"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"
  depends_on "glib"
  depends_on "opus"
  depends_on "vips"
  depends_on "xz"

  on_macos do
    depends_on "gettext"
  end

  def install
    # libvips is a runtime dependency, the brew install location is
    # not discovered by default by Cargo. Upstream issue:
    #   https://codeberg.org/simonrepp/faircamp/issues/45
    ENV.append_to_rustflags Utils.safe_popen_read("pkgconf", "--libs", "opus", "vips").chomp
    system "cargo", "install", *std_cargo_args(features: "libvips")
  end

  test do
    # Check properly compiled with optional libvips feature
    output = shell_output("#{bin}/faircamp --version").chomp
    assert_match version.to_s, output
    assert_match "compiled with libvips", output

    # Check site generation
    catalog_dir = testpath/"Catalog"
    album_dir = catalog_dir/"Artist/Album"
    mkdir_p album_dir
    cp test_fixtures("test.wav"), album_dir/"Track01.wav"
    cp test_fixtures("test.wav"), album_dir/"Track02.wav"
    cp test_fixtures("test.jpg"), album_dir/"artwork.jpg"

    output_dir = testpath/"html"
    system bin/"faircamp", "--catalog-dir", catalog_dir, "--build-dir", output_dir

    assert_path_exists output_dir/"favicon.svg"
    assert_path_exists output_dir/"album/index.html"
    assert_path_exists output_dir/"album/cover_1.jpg"
    assert_path_exists output_dir/"album/1/opus-96/8zjo5mMqlmM/01 Track01.opus"
    assert_path_exists output_dir/"album/2/opus-96/visBSotimzQ/02 Track02.opus"
    assert_path_exists output_dir/"album/1/mp3-v5/tbscAvvooxg/01 Track01.mp3"
    assert_path_exists output_dir/"album/2/mp3-v5/d3t6L5fUbXg/02 Track02.mp3"
  end
end
