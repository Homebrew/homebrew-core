class Foundry < Formula
  desc "Blazing fast, portable and modular toolkit for Ethereum application development"
  homepage "https://github.com/foundry-rs/foundry"
  # `build.rs` in `common` crate requires `.git` repository
  # https://github.com/foundry-rs/foundry/blob/4072e48705af9d93e3c0f6e29e93b5e9a40caed8/crates/common/build.rs#L9-L12
  url "https://github.com/foundry-rs/foundry.git",
      tag:      "v1.9.0",
      revision: "6056c5845d34205a83cf7108042adb137325c9df"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/foundry-rs/foundry.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "23262a3b3938abbf2c47789232148372e756bfe07f445a24cd8ce97451c969ee"
    sha256 cellar: :any, arm64_tahoe:       "b54926e7ae51c6d05f257fa6e6d7ce54ff059803c26cdb0739f1b5cb730d8d01"
    sha256 cellar: :any, arm64_sequoia:     "ac3158b9559e02040f547dda40b2c4cc656c1770a7504463cf46791236b7da99"
    sha256 cellar: :any, arm64_linux:       "966bfbaaa83d26c8541a90fa40a34f10f33569e10246d4d826c97ff3b89c8068"
    sha256 cellar: :any, x86_64_linux:      "95c3ceb234dacfbede5295767aa1809608748538bff391b43797c72f68662e5c"
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
