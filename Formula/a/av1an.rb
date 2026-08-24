class Av1an < Formula
  desc "Cross-platform command-line encoding framework"
  homepage "https://github.com/rust-av/Av1an"
  license "GPL-3.0-only"
  revision 3
  head "https://github.com/rust-av/Av1an.git", branch: "master"

  stable do
    url "https://github.com/rust-av/Av1an/archive/refs/tags/v0.5.2.tar.gz"
    sha256 "58eba4215ffaf07a58065e78fb4aec8df9ebda48e9d996621d559f3024b3538b"

    # Workaround for VapourSynth 74+ until new release
    patch :DATA
  end

  # Differentiate v-prefixed tags from old version schemes
  livecheck do
    url :stable
    regex(/^v(\d+\.\d+\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6408b362fc09ef34a7d5518b4e963f975fbfcab9686605be0aff8b971e9f8ded"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "940cbc4f300478586beeed81b3cbfd1cf8e13e799ab2ce66d1397c8d57ddd72a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1af81225e8802d91363c75c58cfd492308710819c4e9b778db02b2fb612ff45c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cbb38b5c91e2c114fbc06f49ef3c7693e49447efbdff876a151624e5db8275a"
    sha256 cellar: :any,                 arm64_linux:   "c200efae60ac1c56f75b277546d1ebe8cfbb0d54ca683830480d351c0b288223"
    sha256 cellar: :any,                 x86_64_linux:  "cc0d5d979af9062de3ae2d2031749b38e49e3393158385f429732b8a1151fb9b"
  end

  depends_on "rust" => :build
  depends_on "ffmpeg"
  depends_on "mkvtoolnix"
  depends_on "vapoursynth"

  on_intel do
    depends_on "nasm" => :build
  end

  # Fix compatibility with FFmpeg 9.
  patch do
    url "https://github.com/rust-av/Av1an/commit/9bbd829c480e58625842d43b7c8f54962914e9a6.patch?full_index=1"
    sha256 "78a74c9f236141bbc35e1a7e039b5f3b45d730ad7bb7bda62b337b95daf50e55"
  end

  def install
    ENV["VERGEN_GIT_COMMIT_DATE"] = time.iso8601
    ENV["VERGEN_GIT_SHA"] = tap.user
    system "cargo", "install", *std_cargo_args(path: "av1an")

    generate_completions_from_executable(bin/"av1an", "--completions", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/av1an --version")

    cp test_fixtures("test.mp4"), testpath
    system bin/"av1an", "-i", testpath/"test.mp4", "-o", testpath/"test.av1.mkv"
    assert_path_exists testpath/"test.av1.mkv"
  end
end

__END__
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -1030,6 +1030,16 @@ dependencies = [
  "pkg-config",
 ]
 
+[[package]]
+name = "libloading"
+version = "0.9.0"
+source = "registry+https://github.com/rust-lang/crates.io-index"
+checksum = "754ca22de805bb5744484a5b151a9e1a8e837d5dc232c2d7d8c2e3492edc8b60"
+dependencies = [
+ "cfg-if",
+ "windows-link 0.2.1",
+]
+
 [[package]]
 name = "libz-sys"
 version = "1.1.23"
@@ -2042,9 +2052,9 @@ checksum = "ba73ea9cf16a25df0c8caa16c51acb937d5712a8429db78a3ee29d5dcacd3a65"
 
 [[package]]
 name = "vapoursynth"
-version = "0.5.1"
+version = "0.5.6"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "f817dd2eca0813092eecb84c916acef69419da39ee8563d9aeb25118bc927a71"
+checksum = "413b994d9955202f99298ef502dec6d84f1be7603483d19158a365f9fdb8f128"
 dependencies = [
  "anyhow",
  "thiserror",
@@ -2053,9 +2063,12 @@ dependencies = [
 
 [[package]]
 name = "vapoursynth-sys"
-version = "0.5.0"
+version = "0.6.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "0dc01f455bc7ef73678bbcab5332fbe745892fa9466ccefe086de52a32fbce19"
+checksum = "4ef47dc5817613dbe0251eadbe2cea0443edebbb3a551be7b6728314ff44e12e"
+dependencies = [
+ "libloading",
+]
 
 [[package]]
 name = "vcpkg"
