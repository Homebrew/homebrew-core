class Foundry < Formula
  desc "Blazing fast, portable and modular toolkit for Ethereum application development"
  homepage "https://github.com/foundry-rs/foundry"
  url "https://github.com/foundry-rs/foundry/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "db81b0b43ddc8555b6043833d747e9aeba46bc287874b6182b6a90dcfb5678fa"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/foundry-rs/foundry.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4b13feaa2e415a8f0c18093899a10feaaa2dfe3f95213b8c818612754bf5b4c8"
    sha256 cellar: :any,                 arm64_sequoia: "0b6de231d00d2e7ab3b019f8e6da53bc9a21e7eeaf90b6380e885aca7a59946f"
    sha256 cellar: :any,                 arm64_sonoma:  "04c83017ddf3a36db8568052f433872da0b84817156584b81a533bdbdfd8feec"
    sha256 cellar: :any,                 sonoma:        "b28a1bb38d7142e969437e010b9d36813343241b60fa65b1e74244efaf165011"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c15e5e36634e7b9371daf1e055bd0b941ea92a5d45b20e8b17d96f867290dd3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99e4c04ae9fff60df6c7b7eb415ff86883ebe29698662fceaf28cbedf970f953"
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
