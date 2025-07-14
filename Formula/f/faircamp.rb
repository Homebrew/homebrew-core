class Faircamp < Formula
  desc "Static site generator for audio producers"
  homepage "https://codeberg.org/simonrepp/faircamp"
  url "https://codeberg.org/simonrepp/faircamp/archive/1.4.2.tar.gz"
  sha256 "934afbd41118da5dd39164b647fe5c839789a9b8b43c9b7c1aa8b3a056884c35"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "d4b4e1f9a8688e8d9013ad446c0d946d83afd80b0c8f3775d2d4446161c3b92c"
    sha256 cellar: :any, arm64_sonoma:  "2a4567bbe5c0084f8b2c4ce5df0e85479a1407cd5db551a65c3feb436bc26721"
    sha256 cellar: :any, arm64_ventura: "0a60a4ed2110e4f7b0af8d9fb8b7b145016986d378b5f6764273d1ce24458331"
    sha256 cellar: :any, sonoma:        "62323585d09c30d0b575d461065b655ea311f526ece4da8b051a1379dbf237e0"
    sha256 cellar: :any, ventura:       "5d78f5c8ce14bd6d78818a9eb96c73b9bdb270015eab8b20b992c9db61949e90"
  end

  depends_on "opus" => :build
  depends_on "pkgconf" => :build
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
    ENV["RUSTFLAGS"] = Utils.safe_popen_read("pkgconf", "--libs", "vips").chomp
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
