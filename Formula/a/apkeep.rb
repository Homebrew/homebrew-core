class Apkeep < Formula
  desc "Command-line tool for downloading APK files from various sources"
  homepage "https://github.com/EFForg/apkeep"
  url "https://github.com/EFForg/apkeep/archive/refs/tags/0.18.0.tar.gz"
  sha256 "627f2382c3c849cbf872c512cf5f7293d31714b630afdf531ec8a9263bea207e"
  license "MIT"
  head "https://github.com/EFForg/apkeep.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd7187795c6c4dd436f98a4c58a3128f711053df8c15185c75ca232221ae9f9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f1741e4a1fc3a84ffa1ca7dd123c51fdec72afdcdb5a68d02f7b434be3ea4d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7255a509e2350733e8811febb6dc61ac26825a597129cfbb67e91f555175046"
    sha256 cellar: :any_skip_relocation, sonoma:        "62cd9e4b38fb8c9ed221c3e2e1ab1d2a50e29ea82a9e029f55e27abcfc330f6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "feff4312a01787dd43c63e1b073f4881296cd9d0a339b0c9c7708b2040caf438"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85dc722f1671de059f697ba93b8eabcaebfdbf89b36b9ce43d4063b1503bfcbb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/apkeep --version")

    # hello world apk, https://play.google.com/store/apps/details?id=dev.egl.com.holamundo&hl=en_US
    system bin/"apkeep", "--app", "dev.egl.com.holamundo", testpath
    assert_path_exists "dev.egl.com.holamundo.xapk"
  end
end
