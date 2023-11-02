class Fw < Formula
  desc "Workspace productivity booster"
  homepage "https://github.com/brocode/fw"
  url "https://github.com/brocode/fw/archive/refs/tags/v2.18.0.tar.gz"
  sha256 "44ccad2e630b6d8dd46475af957213b49b8062789a25d75f1e1c62feb56a0a6b"
  license "WTFPL"

  # This repository also contains version tags for other tools (e.g., `v4.4.0`
  # is an `fblog` tag), so we can't reliably determine which tags are for `fw`.
  # Upstream only creates GitHub releases from `fw` tags, so we have to check
  # releases instead.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "875421fd91793a39183be5944c2f0068ecb8f4264512208edcf58417a201c28c"
    sha256 cellar: :any,                 arm64_ventura:  "56e8ebc7fe96202cc2646b80171f7eff059588f608f488e30be48fbfe089e1a1"
    sha256 cellar: :any,                 arm64_monterey: "75fbfa0abffeab1936ba1b975322c87ef306c02ad3b50debe97a89b27ae748b1"
    sha256 cellar: :any,                 sonoma:         "34b215956db7b0af4332d57fbfa8bab8440148387bb52391d7213244cb432d5f"
    sha256 cellar: :any,                 ventura:        "55173ecae7af6da3973e0878788cea507b5a1fe5eb824169111810535cdfd5c0"
    sha256 cellar: :any,                 monterey:       "1354ade61189755eb40c1891a1caab814adb309c26a6c91d4296d675149cd912"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea37d64a4fc0a73275af149fb23aecd1b6a3db43d9f23401e4647c002bbd6fa8"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  resource "fw.1" do
    url "https://github.com/brocode/fw/releases/download/v2.18.0/fw.1"
    sha256 "b19e2ccb837e4210d7ee8bb7a33b7c967a5734e52c6d050cc716490cac061470"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    man1.install resource("fw.1")
  end

  test do
    assert_match "Synchronizing everything", shell_output("#{bin}/fw sync 2>&1", 1)
    assert_match "fw #{version}", shell_output("#{bin}/fw --version")
  end
end
