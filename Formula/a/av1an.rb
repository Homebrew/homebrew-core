class Av1an < Formula
  desc "Cross-platform command-line encoding framework"
  homepage "https://github.com/rust-av/Av1an"
  license "GPL-3.0-only"
  revision 1
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e59c6f11824fead9ebdd454be5ededda07cf453f0b68342353a631ced93122f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efd4ff1cf229885f8f242b90d1d6acf94ce42320249daf7ba6b16e8c1c68998f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4da98b6acae00b4c3387e6c09ac1c73bc481258ecee56b44d0ee17199e94cb13"
    sha256 cellar: :any_skip_relocation, sonoma:        "2becd76d0713bd7583bba85ed8c3ff866aefdf06c8f0e9d4c402d046c3ec5c78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29c62ae87a2f908f2de1e134fa87e08f943d70719a8cdac8e55496982a91659a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55bd69992e240b0dcfc1e9ee91d5658a7d83100c81b4e260bfd22ea0bfa3f5ae"
  end

  depends_on "rust" => :build
  depends_on "ffmpeg"
  depends_on "mkvtoolnix"
  depends_on "vapoursynth"

  on_intel do
    depends_on "nasm" => :build
  end

  def install
    ENV["VERGEN_GIT_COMMIT_DATE"] = time.iso8601
    ENV["VERGEN_GIT_SHA"] = tap.user
    system "cargo", "install", *std_cargo_args(path: "av1an")

    generate_completions_from_executable(bin/"av1an", "--completions", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/av1an --version")

    system bin/"av1an", "-i", test_fixtures("test.mp4"), "-o", testpath/"test.av1.mkv"
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
