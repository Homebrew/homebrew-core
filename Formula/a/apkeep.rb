class Apkeep < Formula
  desc "Command-line tool for downloading APK files from various sources"
  homepage "https://github.com/EFForg/apkeep"
  url "https://github.com/EFForg/apkeep/archive/refs/tags/1.0.0.tar.gz"
  sha256 "0c7a9c84b5dff12c356b22878e4f88ff3f1b44500ff80436c9e64cee17146388"
  license "MIT"
  head "https://github.com/EFForg/apkeep.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "965dc2b86a46baf0d1e9d8b589939f4b710435ee7c95a7c83d3a8558a7bac46c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4dfe63e1fcab476184a2d0f8aa56f45b805d1f07b7d2fdc460f388324a313286"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20436b7b3d5b419ed0adf748845138820d64259a29145241278c10996d8e23d1"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb37623192c9d223be4588150c3fdaa141094882632a0b46bd5ea5869c987e90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c38626aac992337f797dd8c51082fa89e81bf0f3f2244f828f58d935d95cc09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "929ef5f479c16ebf5e521b0d8c3fc4bc63e25d022eb510859dd82befc696f82e"
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
