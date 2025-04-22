class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://github.com/ravachol/kew/archive/refs/tags/v3.1.2.tar.gz"
  sha256 "9f888090e458763962b91e25e01ea36d37f71be2ec69e2870c801287cd0c42e9"
  license "GPL-2.0-only"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "93cd9e807d32cd0949893fa4d41cc4806239e1a3f07e184171fad0ff66f16358"
    sha256 cellar: :any,                 arm64_sonoma:  "cc0afad845e2e2a683e094d8b477dfdebcf3d3f719cdb1679202b0f03328e504"
    sha256 cellar: :any,                 arm64_ventura: "8409f207003b286a1eaf8d63df70074d12d0c37c45b7aa0d73054ea2203ca8f9"
    sha256 cellar: :any,                 sonoma:        "ace627d70569cae3b37b2df55d9459a0bc1a0dcf5b6db780e4fbe1af1adf89fc"
    sha256 cellar: :any,                 ventura:       "3155803d178b14e49d0241bc7091726477b99a0f0aa2f0d7b4850bd826702bca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65fc9912217dffa2e5191d38748e55da10c749633e34c6f4a2023e1e761c1b30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "033ea60a7dd52b3d04298e2061ac01e7969f2c7e79f0aff37a887ddda1c92782"
  end

  depends_on "pkgconf" => :build
  depends_on "chafa"
  depends_on "faad2"
  depends_on "fftw"
  depends_on "glib"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "opusfile"
  depends_on "taglib"

  uses_from_macos "curl"

  on_macos do
    depends_on "gettext"
    depends_on "opus"
  end

  on_linux do
    depends_on "libnotify"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
    man1.install "docs/kew.1"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath/".config"

    (testpath/".config/kew").mkpath
    (testpath/".config/kew/kewrc").write ""

    system bin/"kew", "path", testpath

    output = shell_output("#{bin}/kew song")
    assert_match "No Music found.\nPlease make sure the path is set correctly", output

    assert_match version.to_s, shell_output("#{bin}/kew --version")
  end
end
