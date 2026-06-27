class Foundry < Formula
  desc "Blazing fast, portable and modular toolkit for Ethereum application development"
  homepage "https://github.com/foundry-rs/foundry"
  # `build.rs` in `common` crate requires `.git` repository
  # https://github.com/foundry-rs/foundry/blob/4072e48705af9d93e3c0f6e29e93b5e9a40caed8/crates/common/build.rs#L9-L12
  url "https://github.com/foundry-rs/foundry.git",
      tag:      "v1.7.1",
      revision: "4072e48705af9d93e3c0f6e29e93b5e9a40caed8"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/foundry-rs/foundry.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "119bb98930237ad9d2e9ad01f43681e5f77db1a7bbaa22e6c151430b26e1dfce"
    sha256 cellar: :any,                 arm64_sequoia: "8770d61a8b838e17e09ab9bf79cc597f8218469231e4ce29e9e89f762b071459"
    sha256 cellar: :any,                 arm64_sonoma:  "e38cf2ed6246727f90875be95b3fd0571cf7d7cc63c2b02a90969ddc8bbf40c8"
    sha256 cellar: :any,                 sonoma:        "9f089ce540310c86282e349921859da3025fbb2ec4b4341e407a4266171a31dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b910d388c08e13fa833c4784d0064faf15373d259ec5f64878e776cbe6804fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8606052819eb6057fcd57918c79a4e53203eaf3f7dc783b1d0e32e38757f738c"
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
