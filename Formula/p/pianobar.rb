class Pianobar < Formula
  desc "Command-line player for https://pandora.com"
  homepage "https://6xq.net/pianobar/"
  url "https://6xq.net/pianobar/pianobar-2024.12.21.tar.bz2"
  sha256 "16f4dd2d64da38690946a9670e59bc72a789cf6a323f792e159bb3a39cf4a7f5"
  license "MIT"
  revision 1
  head "https://github.com/PromyLOPh/pianobar.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?pianobar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "384c9d511862df579e9edd7e91367408b01841ec5926c239c04680e4f3dad505"
    sha256 cellar: :any,                 arm64_sequoia: "7d91f1b3141a04ae0dad7baf5cf04ed4f3c79e0bb716fd4fc6e7961441fa2d15"
    sha256 cellar: :any,                 arm64_sonoma:  "133aa95d8f02358517e87d5afbb0e3a13463be0b03a543cc84181fa4ce90402a"
    sha256 cellar: :any,                 arm64_ventura: "a8036ec711387dd1e58b765777538d1bf5dde7d16e2c0aec05d80032a8f8ade1"
    sha256 cellar: :any,                 sonoma:        "e9fce5e9ddfe9a904f139db4ebcd03b78700bbeafbc9abe4e7c40a6c7290039a"
    sha256 cellar: :any,                 ventura:       "8cc83ae82d7f51480f62258273093c9e51c0cf1cd0911c8bc72f32276602c013"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e44848c2f000bfe6e4974e4bfdd1384fe4acbe2e02e260897cc840980be51c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cba151913c6d32be73748df86c72b88eb28769c718d6d7c8f3378aa175145d9"
  end

  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "json-c"
  depends_on "libao"
  depends_on "libgcrypt"

  uses_from_macos "curl"

  def install
    # Discard Homebrew's CFLAGS as Pianobar reportedly doesn't like them
    ENV["CFLAGS"] = "-O2 -DNDEBUG " +
                    # Or it doesn't build at all
                    "-std=c99 " +
                    # build if we aren't /usr/local'
                    "#{ENV.cppflags} #{ENV.ldflags}"
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"

    prefix.install "contrib"
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    require "pty"
    PTY.spawn(bin/"pianobar") do |stdout, stdin, _pid|
      stdin.putc "\n"
      assert_match "pianobar (#{version})", stdout.read
    end
  end
end
