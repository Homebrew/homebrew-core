class Faircamp < Formula
  desc "Static site generator for audio producers"
  homepage "https://codeberg.org/simonrepp/faircamp"
  url "https://codeberg.org/simonrepp/faircamp/archive/1.3.0.tar.gz"
  sha256 "8bec1de6dc2ffac76df8d046f0c20556b6ff89a639be4cbb30847aefa76fa545"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "51a47d2cf95164e32913b9f8980de2adc553ea447680d399dda48edf6d076613"
    sha256 cellar: :any, arm64_sonoma:  "d708eacb18bbe295ac0dd6fe40df9ce8c597a94d7f3d7db1a4b0272cbbd47645"
    sha256 cellar: :any, arm64_ventura: "8f91ef5b65bbe15d7ebaa78f300f98a08cefa1ebe11ddce9effddcad74ec289d"
    sha256 cellar: :any, sonoma:        "0279cddbcdf690847d7b66233906c8a5e0f1363611ecd23d2635288b686303bf"
    sha256 cellar: :any, ventura:       "2a0b021105c831a5ab8589633f9338c15f4fb45e3b1a69606296860e6c5953eb"
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
