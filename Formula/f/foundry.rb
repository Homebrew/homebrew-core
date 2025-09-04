class Foundry < Formula
  desc "Blazing fast, portable and modular toolkit for Ethereum application development"
  homepage "https://github.com/foundry-rs/foundry"
  url "https://github.com/foundry-rs/foundry/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "ad9ea42349d11a205cd6e29ec8fab6853fd026dc37ccc8dba383635f446ae948"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/foundry-rs/foundry.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "03e83a36fa00eec0f8e79828d217a5b1672d0dfe193eab5aaa02c0d524dcc3aa"
    sha256 cellar: :any,                 arm64_sonoma:  "601ab2ec1427a1c080a27c4f8c84ade80da5d4c27cbb3ea523ac4394dfba9bce"
    sha256 cellar: :any,                 arm64_ventura: "3a0a6943a962f20038dffb679c14cb41b3fdb9ce1681f209b00b0dd0af6c42c8"
    sha256 cellar: :any,                 sonoma:        "dc52a3b20028928291cc8e6859ef1a835a0a71de1ecaab393e8d271ec9521274"
    sha256 cellar: :any,                 ventura:       "11dccd2c767577b0b84886a7dd711e9da6b3101ba930abc7bf3dac8d6257ba2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ae10b320e1c3578006d6b5a4ba7e0ff16bd4923089ddf66b45ce24b8ee9d8c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eacb0bfa349c02a15e041e25a59731e5203f0a5bc1414e4a9ceeb442904c865c"
  end

  depends_on "help2man" => :build
  depends_on "rust" => :build

  on_macos do
    depends_on "libusb"
  end

  conflicts_with "chisel-tunnel", because: "both install `chisel` binaries"
  conflicts_with "jboss-forge", because: "both install `forge` binaries"

  def install
    ENV["TAG_NAME"] = tap.user

    %w[forge cast anvil chisel].each do |binary|
      system "cargo", "install", *std_cargo_args(path: "crates/#{binary}")

      # https://book.getfoundry.sh/config/shell-autocompletion
      generate_completions_from_executable(bin/binary.to_s, "completions") if binary != "chisel"

      system "help2man", bin/binary.to_s, "-o", "#{binary}.1", "-N"
      man1.install "#{binary}.1"
    end
  end

  test do
    project = testpath/"project"
    project.mkpath
    cd project do
      # forge init will create an initial git commit, which will fail if an email is not set.
      ENV["EMAIL"] = "example@example.com"
      system bin/"forge", "init"
      assert_path_exists project/"foundry.toml"
      assert_match "Suite result: ok.", shell_output("#{bin}/forge test")
    end

    assert_match "Decimal: 2\n", pipe_output("#{bin}/chisel", "1+1")

    anvil_port = free_port
    anvil = spawn bin/"anvil", "--port", anvil_port.to_s
    sleep 2
    assert_equal "31337", shell_output("#{bin}/cast cid -r 127.0.0.1:#{anvil_port}").chomp
  ensure
    if anvil
      Process.kill("TERM", anvil)
      Process.wait anvil
    end
  end
end
