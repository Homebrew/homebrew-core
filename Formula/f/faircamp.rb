class Faircamp < Formula
  desc "Static site generator for audio producers"
  homepage "https://codeberg.org/simonrepp/faircamp"
  url "https://codeberg.org/simonrepp/faircamp/archive/1.7.0.tar.gz"
  sha256 "199328a20ad82ffc45f6f96cbd472f72a55dfeee87b2be18559c19e9367d5408"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4194ed50aea3d486e72f7a64b53b467c73dacc876ed2dc93d3ab7d9dbfd4995c"
    sha256 cellar: :any,                 arm64_sequoia: "063c1f134affe188066c42ee2cc0718bbac6462125bc5cdfba4df8f67f45b025"
    sha256 cellar: :any,                 arm64_sonoma:  "a0e2b180235aec66de1e6f5dae19b70351820705dcd82963e181431b3be07cc0"
    sha256 cellar: :any,                 sonoma:        "3e37398d846b3710c540b6f177943b3486993265282b0342012fc105d633eeea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90b5aaff9681e96c735a215837d73bf8c9f73b0916ae7af46ad0037229655743"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1ddaedfd2a098f6f8875c644d3ece063665cb50c73c8e511c8295a359e79915"
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
    assert_path_exists output_dir/"album/index.html"
    assert_path_exists output_dir/"album/cover_1.jpg"
    assert_path_exists output_dir/"album/1/opus-96/8zjo5mMqlmM/01 Track01.opus"
    assert_path_exists output_dir/"album/2/opus-96/visBSotimzQ/02 Track02.opus"
    assert_path_exists output_dir/"album/1/mp3-v5/tbscAvvooxg/01 Track01.mp3"
    assert_path_exists output_dir/"album/2/mp3-v5/d3t6L5fUbXg/02 Track02.mp3"
  end
end
