class GitXet < Formula
  desc "Git LFS plugin that uploads and downloads using the Xet protocol"
  homepage "https://github.com/huggingface/xet-core"
  url "https://github.com/huggingface/xet-core/archive/refs/tags/git-xet-v0.2.1.tar.gz"
  sha256 "df2a90a8266918bf2aba35e22276c745d11bd9c39850410f78ebbf2b50d0c87c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^git[._-]xet[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fa293bcf41e4dd054600a3c5d313dbd8926ea20649995ebd19841880f93c3d87"
    sha256 cellar: :any, arm64_sequoia: "d27e811791f23f5a22ec87c2564d84aeb6147da89f0b6e32462f769bbff5fa53"
    sha256 cellar: :any, arm64_sonoma:  "129f5809c2fad4547ea1c3bc329b634d00f5d0bfa8d84b8f59394e811da4db91"
    sha256 cellar: :any, sonoma:        "ad5184c34799464346c53ddbaae67eae1a6bbe434e0258dc459408505681d9f9"
    sha256               arm64_linux:   "ec75d7c4ae3420eb6f6a7bd0a247d1b40b626492f65ad512afbda27d87b71e44"
    sha256               x86_64_linux:  "a2695818b043d4c2bd65b81b958cab2ef31af417d3270724fad2a736d873e523"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "git-lfs"
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "git_xet")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-xet --version")
    system "git", "init"
    system "git", "xet", "track", "test"
    assert_match "test filter=lfs", (testpath/".gitattributes").read
  end
end
