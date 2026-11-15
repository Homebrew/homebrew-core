class Apkeep < Formula
  desc "Command-line tool for downloading APK files from various sources"
  homepage "https://github.com/EFForg/apkeep"
  url "https://github.com/EFForg/apkeep/archive/refs/tags/1.1.0.tar.gz"
  sha256 "20407a9420cb2a47a8801d744a8ebeefff5d0cc62c5a956445724fb5cde5897c"
  license "MIT"
  head "https://github.com/EFForg/apkeep.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "301d1aebc359ffb42f003690fe42eb7e93406c8a0d922df177bee496da40d4ef"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4567991fb169f4cb484aa8fa1dcea36532113517c272ad325c8692b4a2c348f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6f0c9690ab19d1e2704227fcb502fad07d04bfde5ae3e8a79022418320882286"
    sha256 cellar: :any,                 arm64_linux:       "37938e8da3d68a42277fc77f07251570a9121a87dd998b6f897c3107de425445"
    sha256 cellar: :any,                 x86_64_linux:      "a83b06e6c76217d2fb782910123235986a3cf89f5fe625f659f99b41b9f36a55"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/apkeep --version")

    # hello world apk, https://play.google.com/store/apps/details?id=dev.egl.com.holamundo&hl=en_US
    system bin/"apkeep", "--download-source", "apk-pure", "--options", "acknowledge_dangers=true",
           "--app", "dev.egl.com.holamundo", testpath
    assert_path_exists "dev.egl.com.holamundo.xapk"
  end
end
