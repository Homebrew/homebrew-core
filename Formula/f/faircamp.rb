class Faircamp < Formula
  desc "Static site generator for audio producers"
  homepage "https://codeberg.org/simonrepp/faircamp"
  url "https://codeberg.org/simonrepp/faircamp/archive/1.1.1.tar.gz"
  sha256 "ecb9a30a505b0453900457d5f9396833eb458545d97f4ce46c219a90ead4708d"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "15fe13c4aad78c55845b091f59fcea621a9572ce6a6e38b1d78f3dcce9040fd7"
    sha256 cellar: :any, arm64_sonoma:  "123a3da0b6284fbfe3c54bc962ff65de6496f112278b0844e338ee927245a4f3"
    sha256 cellar: :any, arm64_ventura: "499a81eb70c10c88c61d9856966ad53083e87ec8305205265f9525b7a494409c"
    sha256 cellar: :any, sonoma:        "c63c0ad116f50685818ad075c058e14b020277df392331a410ab465c7ae2b69b"
    sha256 cellar: :any, ventura:       "596df903481b43535c11dbf53c81c00c719da2ad676458e847097c7e80a0dcc7"
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
    version_str = shell_output("#{bin}/faircamp --version").chomp
    assert_match "faircamp #{version} (compiled with libvips)", version_str

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
    assert_path_exists output_dir/"album"/"opus-96"/"ASINtk0hKII"/"01 Track01.opus"
    assert_path_exists output_dir/"album"/"opus-96"/"uWPoxZFX0kQ"/"02 Track02.opus"
    assert_path_exists output_dir/"album"/"mp3-v5"/"1syLQAjRlm8"/"01 Track01.mp3"
    assert_path_exists output_dir/"album"/"mp3-v5"/"zh4GTzy3VT0"/"02 Track02.mp3"
  end
end
