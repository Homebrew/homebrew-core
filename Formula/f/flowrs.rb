class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/flowrs-tui-v0.13.5.tar.gz"
  sha256 "4d613fc92bb31eaa3a51e31a25d42900a99de2b4450c6cc80e9d1ac9ce5b654e"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^flowrs-tui-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "caa860df246f0d307adb63cc63c17ca7aba0da7ce8958e115ae278c80f1a3ae6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f24bc1c33324d16f75f68e684170d6ca2fe381a0ebddd63e539d3a44187f878"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b893eeaed4ef4fa0e13bc0017e596b66b7ff31e2ffdf6ba3637c301afd6a9bad"
    sha256 cellar: :any_skip_relocation, sonoma:        "8284549fa10148c69a5cae5e86ec25917ba9cc9f3d43cdac01913c03d6ca04a7"
    sha256 cellar: :any,                 arm64_linux:   "c48fec61e6f5f787090f832fb3798e8b2b3263fba333e5ce3731e6d1aee840dd"
    sha256 cellar: :any,                 x86_64_linux:  "73ba645a584b09e4fecbdebf4c8434faa60192e1f946252a0551fd7507f35172"
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
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end
