class Foundry < Formula
  desc "Blazing fast, portable and modular toolkit for Ethereum application development"
  homepage "https://github.com/foundry-rs/foundry"
  # `build.rs` in `common` crate requires `.git` repository
  # https://github.com/foundry-rs/foundry/blob/4072e48705af9d93e3c0f6e29e93b5e9a40caed8/crates/common/build.rs#L9-L12
  url "https://github.com/foundry-rs/foundry.git",
      tag:      "v1.8.3",
      revision: "cae51ad458f6abb64852b7709eb784352429825d"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/foundry-rs/foundry.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fbf2e7d3332b09d167f7096e8f30c83c15909dcbed104754a902c7528ada6533"
    sha256 cellar: :any, arm64_tahoe:       "faea750f1448b8511ea5e66354ae02bd00d4c349ceebb675ec435052674b878c"
    sha256 cellar: :any, arm64_sequoia:     "4662c0b21e41e72967335114b8b5f600d16f34af2f60c4ea9ab70022bbc356ae"
    sha256 cellar: :any, arm64_linux:       "f963c0db9ee6340c792108767cf724b61e8649aad78056591702f3ff636f3063"
    sha256 cellar: :any, x86_64_linux:      "d58a8e1e1c97d596a69838285c01fe23fb52a6c8de0ddddb9a0ff56a0b9358df"
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
