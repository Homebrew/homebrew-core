class Foundry < Formula
  desc "Blazing fast, portable and modular toolkit for Ethereum application development"
  homepage "https://github.com/foundry-rs/foundry"
  url "https://github.com/foundry-rs/foundry/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "1c3aeaa2f34d812c598c3c5ea996be154bcf5604b9cbea0af0901b3dbe8e4600"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/foundry-rs/foundry.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d10d6f1d4f608af12fee2b0d5acd0d46149ab171f9cc91e1ded7b52caa7a02ab"
    sha256 cellar: :any,                 arm64_sequoia: "76424dd401bbb3e7d0f75196a378b7205d6b3c9416c319d46bf8a4cfea2372e3"
    sha256 cellar: :any,                 arm64_sonoma:  "984213d2d0ff32a21fd0652a910e6574b0bc3f10d70fbdd7ea554d999e7f890d"
    sha256 cellar: :any,                 sonoma:        "3fa93ea839450ffe3bdf5a2903ecc5c22d0ed28f805d9f82e21b35a06e9ece1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c196da5a75be8eb147e84af7cd387d4207b597508016f53d291d25d11d2de869"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "453027b09191e33b00015be9a4b2c806d6bf626a2d223c08a10f03a23f3e0fd0"
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
