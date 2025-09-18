class Faircamp < Formula
  desc "Static site generator for audio producers"
  homepage "https://codeberg.org/simonrepp/faircamp"
  url "https://codeberg.org/simonrepp/faircamp/archive/1.6.0.tar.gz"
  sha256 "c8d43e2618928de3935646fba4f85fa8d0dd23a5d11ea10f081fa430aa79d5b9"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d6060e8bde8474a3f6088b9f795d4dddd341267828bef8c7925eda0ec7a65b5f"
    sha256 cellar: :any,                 arm64_sequoia: "416b0bd05534a421cd9dfeed72ea03f06cbc856285dd4fd4b6429e2c995ebe42"
    sha256 cellar: :any,                 arm64_sonoma:  "fd353d91775c5b4841203160f9e5f4032a2838dcdf2a6264d2a5ceb0840ab99d"
    sha256 cellar: :any,                 arm64_ventura: "5b4a63af1e44bb8d3b0e0a8c8601bc6cfb91858634712320523b38443302f62c"
    sha256 cellar: :any,                 sonoma:        "bc77d9686ef45d9b50dfe0a37678d15491e03e93336b90aeea59bd4027126951"
    sha256 cellar: :any,                 ventura:       "8c68f0948cd28f567cc110ff58cb500b3dc222ead293cba95048a903b34f0bfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4026686ab3c905d1afce726db05f6c80b30804417c27d6daca209402d882601f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"
  depends_on "gettext"
  depends_on "glib"
  depends_on "opus"
  depends_on "vips"
  depends_on "xz"

  def install
    # libvips is a runtime dependency, the brew install location is
    # not discovered by default by Cargo. Upstream issue:
    #   https://codeberg.org/simonrepp/faircamp/issues/45
    ENV.append_to_rustflags Utils.safe_popen_read("pkgconf", "--libs", "opus", "vips").chomp
    system "cargo", "install", *std_cargo_args, "--features", "libvips"
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
    assert_path_exists output_dir/"album"/"index.html"
    assert_path_exists output_dir/"album"/"cover_1.jpg"
    assert_path_exists output_dir/"album"/"1"/"opus-96"/"8zjo5mMqlmM"/"01 Track01.opus"
    assert_path_exists output_dir/"album"/"2"/"opus-96"/"visBSotimzQ"/"02 Track02.opus"
    assert_path_exists output_dir/"album"/"1"/"mp3-v5"/"tbscAvvooxg"/"01 Track01.mp3"
    assert_path_exists output_dir/"album"/"2"/"mp3-v5"/"d3t6L5fUbXg"/"02 Track02.mp3"
  end
end
