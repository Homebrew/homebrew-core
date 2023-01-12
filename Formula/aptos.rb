class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptoslabs.com/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v1.0.4.tar.gz"
  sha256 "403b60bd98b6456a0c42c58f1e3a5f9297ca1ce29afdf31667bdc7771cceeb36"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4567cfb78d06bcbe404c68beee9e1417b38eff99d4f555715bfcf6880191feb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13e08cb42c171f4bd63d1db2abff538e23ee6d56dda95d17a74683695ca88b7a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee5355bb044d07877b12341f214a074af9d7a18ca8c079ee2deb4ec73253272d"
    sha256 cellar: :any_skip_relocation, ventura:        "23544d0482551e4b67a3ec8dc51cbbec8d1117945e01e4ef1a725476faa954f1"
    sha256 cellar: :any_skip_relocation, monterey:       "94a7e3fd045127c6c611ba8480cf90b632ecf2d243f511e7fb16198f48723a94"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd892d123ece9875e56a17efb013f39e71382c3a2574a9c858e1917f1dbc82a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c385a80852019d610a6cab6935c277cecfd03c4b619b3b055a6899449808804a"
  end

  depends_on "cmake" => :build
  depends_on "rustup-init" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "zip" => :build
    depends_on "openssl@3"
    depends_on "systemd"
  end

  def install
    system "#{Formula["rustup-init"].bin}/rustup-init",
      "-qy", "--no-modify-path", "--default-toolchain", "1.64"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    system "./scripts/cli/build_cli_release.sh", "homebrew"
    bin.install "target/cli/aptos"
  end

  test do
    assert_match(/output.pub/i, shell_output("#{bin}/aptos key generate --output-file output"))
  end
end
