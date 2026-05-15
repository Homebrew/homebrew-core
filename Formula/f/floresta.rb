class Floresta < Formula
  desc "Lightweight and embeddable Bitcoin client, built for sovereignty"
  homepage "https://getfloresta.org"
  url "https://github.com/getfloresta/Floresta/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "47dbff1991bd9ee8f8880a0762e4c7ee8b095b93c755529a6e0805fa9ea1cf9f"
  license any_of: [
    "MIT",
    "Apache-2.0",
  ]
  head "https://github.com/getfloresta/Floresta.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ba412b48e231c0e21051fa442177a6697709361495d100d6b6ee16e6d47d755"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e3c70b99d0b4fda14040188eea45f159209f983f8947b6144256323d72b2a4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "434e944254bf76417f6edc3742c7fe8660b7e2842d68def4e886d967a9771bec"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c0914f6e642b655eea1c5f5ca2c619723f65eadd2f78fedd7af795363190026"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f474d469550bf62d70d0ba7439d870285860f68ba24a1f87fef96aacf1a9b5af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd56abbba28df8300678a7ef2db4570d9ea19dbbff35a44fe68ab4f767338fa2"
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
