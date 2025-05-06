class Faircamp < Formula
  desc "Static site generator for audio producers"
  homepage "https://codeberg.org/simonrepp/faircamp"
  url "https://codeberg.org/simonrepp/faircamp/archive/1.4.0.tar.gz"
  sha256 "f0966203417f73664c0a88ceddef249d54fdd64cfbb5819564ac496d2376ef0b"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "1c86f0ade713cfef2a77cda052d566859e22c8fa309324b93c95d910f918346f"
    sha256 cellar: :any, arm64_sonoma:  "bd572ca10c3545edbb295b75460d7edaa01f813789335f0fde1541be906fd284"
    sha256 cellar: :any, arm64_ventura: "88d895bf0ee2572c9470b143f2c14d88c2fc66fc483cbc34c7fb94c794b61125"
    sha256 cellar: :any, sonoma:        "cb12fdaf1c4ee02af3e427ff2b5c30e5da48bd87bbe7c92da5d9046b7567228a"
    sha256 cellar: :any, ventura:       "cfcc73ed66fe91c56cf82a4b96014cb4c479a6a409ab578fe804da36c9da3351"
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
