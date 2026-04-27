class Floresta < Formula
  desc "Lightweight and embeddable Bitcoin client, built for sovereignty"
  homepage "https://getfloresta.org"
  url "https://github.com/getfloresta/Floresta/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "1a484842451ea3b35c5f9686cc8955cad23923eddf166f373dd3e994e64a7ee7"
  license any_of: [
    "MIT",
    "Apache-2.0",
  ]
  head "https://github.com/getfloresta/Floresta.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3f3ee1082b13ca1aa6fc1fdaa98f8b6639b9719e847a737db7c4da08158ba8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "635e39430ce0d5400db337e9a927827a932e427a16905641cc8f4b751f1ec4db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "801777d966511da07247471d94656149754d9d94715a0be6e058073b9ff6ea3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "92fdee27eda28d945e82b8372710be103b6f693b3775e7c537a074258585585f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39f3dda1ac7e0a6807510eeb868276e7059790cf2e8ef45fbb4ecd98d6598348"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c61969fc684bb549eb75e2f812b33cdfe48c61ef4de877dcd9be76792bb71fe"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "gcc" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    ENV["LIBCLANG_PATH"] = Formula["llvm"].opt_lib.to_s
    system "cargo", "install", *std_cargo_args(path: "bin/florestad")
    system "cargo", "install", *std_cargo_args(path: "bin/floresta-cli")
  end

  service do
    run opt_bin/"florestad"
  end

  test do
    pid = spawn bin/"florestad", "--network", "regtest", "--data-dir", testpath.to_s
    sleep 2
    sleep 4 if OS.mac? && Hardware::CPU.intel?

    output = shell_output("#{bin}/floresta-cli --network regtest getblockchaininfo")
    genesis_regtest = "0f9188f13cb7b2c71f2a335e3a4fc328bf5beb436012afca590b1a11466e2206"

    assert_match genesis_regtest, output
  ensure
    Process.kill("SIGINT", pid)
    Process.wait(pid)
  end
end
