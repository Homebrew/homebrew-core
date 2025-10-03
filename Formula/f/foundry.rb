class Foundry < Formula
  desc "Blazing fast, portable and modular toolkit for Ethereum application development"
  homepage "https://github.com/foundry-rs/foundry"
  url "https://github.com/foundry-rs/foundry/archive/refs/tags/v1.3.6.tar.gz"
  sha256 "897e70f0f96760fb49150688a231453b5aba444a2f4480360dcd677c8adaf72f"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/foundry-rs/foundry.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4be6b1763baccb24fbf768f99a644818cbb809f0c602c024fa269806d31d5c0e"
    sha256 cellar: :any,                 arm64_sequoia: "f1a8b6b9ad24c00371c7b64bbe34bec910980e46f307c9aec2484b27347aa795"
    sha256 cellar: :any,                 arm64_sonoma:  "5c5fed4d8bb0cfe4340890661e985702421da87816751f81985b0292ed8f733b"
    sha256 cellar: :any,                 sonoma:        "08fb04fc60f964f4651a93d88bf401605d990c26cca8329a5e8528ee1105b4d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5839547b6b5b60b1c00012fa18247df2d6a837dc7531890544e6154bc42d38fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d27ea0aff928f1a2dd3f76f17b65f28fa5b05448a0b6ac546c1c2f3c2510d7d"
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
