class Faircamp < Formula
  desc "Static site generator for audio producers"
  homepage "https://codeberg.org/simonrepp/faircamp"
  url "https://codeberg.org/simonrepp/faircamp/archive/1.5.0.tar.gz"
  sha256 "d418252e111b1aa2562e93968205c8fd1507fab19032531875adc11b4740babc"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "4f0729439efd98c19808fc801fa003c71a74da74f169bf64f01243c3a91579a0"
    sha256 cellar: :any, arm64_sonoma:  "94ea3ee87a5d22fd30debd7be0d54f9248de3a7fc908a7cd0374fab043a95523"
    sha256 cellar: :any, arm64_ventura: "e844e29cdb8ca8f036031826467c3630e7ddbf9a4d4b51fef068e7ae4ca459fc"
    sha256 cellar: :any, sonoma:        "914e35f658e9372c4980db1141e8793ff9bb21beef7dd45aa9f8b43b06cb03bd"
    sha256 cellar: :any, ventura:       "4decaa94db573d69ed76282c192bb3a82f51b04724c0e1a7272d38942625f488"
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
    ENV.append_to_rustflags Utils.safe_popen_read("pkgconf", "--libs", "vips").chomp
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
