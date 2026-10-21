class Foundry < Formula
  desc "Blazing fast, portable and modular toolkit for Ethereum application development"
  homepage "https://github.com/foundry-rs/foundry"
  # `build.rs` in `common` crate requires `.git` repository
  # https://github.com/foundry-rs/foundry/blob/4072e48705af9d93e3c0f6e29e93b5e9a40caed8/crates/common/build.rs#L9-L12
  url "https://github.com/foundry-rs/foundry.git",
      tag:      "v1.8.5",
      revision: "51a52c59cffd940f76eddd0b4bb1791aa4b5ac7f"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/foundry-rs/foundry.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e0f51036c87e4a318cb29339daf378a20143de4bce7ae233eddc12cc2fd4a3f0"
    sha256 cellar: :any, arm64_tahoe:       "74889acf85e6613a506896a6ccd2769b6c87501470f01326302ca179c14528d3"
    sha256 cellar: :any, arm64_sequoia:     "e6111a8ca9b5a10ae4ae2bc376d461c1c83ede8cc56e6346e4b3971c1c5a5993"
    sha256 cellar: :any, arm64_linux:       "0630aaf40540702592b3a75e8724d1f0a567db35108cd5317e2feeb3adf5cb3a"
    sha256 cellar: :any, x86_64_linux:      "eccdbe6aaa1a44036f32941a7899e727653ae57827a9773f8c4cd7273b0eac26"
  end

  depends_on "help2man" => :build
  depends_on "rust" => :build

  on_macos do
    depends_on "libusb"
  end

  conflicts_with "chisel-tunnel", because: "both install `chisel` binaries"
  conflicts_with "chisel-ubuntu", because: "both install `chisel` binaries"
  conflicts_with "jboss-forge", because: "both install `forge` binaries"

  def install
    ENV["TAG_NAME"] = tap.user

    # matches features from the official foundry release workflow
    # https://github.com/foundry-rs/foundry/blob/61ae26af36320d4fa1020f7db53785885e29eeb5/.github/workflows/release.yml#L18-L24
    features = %w[aws-kms gcp-kms turnkey cli asm-keccak js-tracer monad optimism]
    features << "touch-id" if OS.mac? && Hardware::CPU.arm?
    features << "jemalloc" if OS.mac? || Hardware::CPU.intel?

    build_args = %w[build --release --bins --no-default-features]
    build_args += ["--features", features.join(",")]

    cargo_args = std_cargo_args.reject { |arg| arg.start_with?("--root=", "--path=") }
    system "cargo", *build_args, *cargo_args

    %w[forge cast anvil chisel].each do |binary|
      bin.install "target/release/#{binary}"

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
