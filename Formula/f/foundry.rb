class Foundry < Formula
  desc "Blazing fast, portable and modular toolkit for Ethereum application development"
  homepage "https://github.com/foundry-rs/foundry"
  # `build.rs` in `common` crate requires `.git` repository
  # https://github.com/foundry-rs/foundry/blob/4072e48705af9d93e3c0f6e29e93b5e9a40caed8/crates/common/build.rs#L9-L12
  url "https://github.com/foundry-rs/foundry.git",
      tag:      "v1.10.1",
      revision: "7c15a1dd0ca75f2b4d6d7961ac55aacbe5cf6378"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/foundry-rs/foundry.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "18d94d1259ae88217cd937a9b03ab49dfb20225820d62bef46f2b819fdd02a94"
    sha256 cellar: :any, arm64_golden_gate: "cc34b617ea2474849d87b1f742489b15f98aeaad6bf754cb80ca068c66577f6e"
    sha256 cellar: :any, arm64_tahoe:       "7a6041cc0546a7c416e4ede1810d0f7cd2675c10218231881f8ec23d72164467"
    sha256 cellar: :any, arm64_sequoia:     "a8c2710de2fec57dfe62b377162f2e2e6c380e98af4d7d4c9d8eb160446a353b"
    sha256 cellar: :any, arm64_linux:       "1a0f218adc55edb3dff6feb24f33fc8bd248a74805e6b38a0fba3a8ebf0c884c"
    sha256 cellar: :any, x86_64_linux:      "1f8254e2311a6909f776778d633bceb632f45b15f6ef26b8afde796b6fd7c3fa"
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
    with_test_process(bin/"anvil", "--port", anvil_port.to_s) do
      sleep 2
      assert_equal "31337", shell_output("#{bin}/cast cid -r 127.0.0.1:#{anvil_port}").chomp
    end
  end
end
