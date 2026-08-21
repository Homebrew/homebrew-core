class Honker < Formula
  desc "SQLite message queue extension"
  homepage "https://honker.dev"
  url "https://static.crates.io/crates/honker-extension/honker-extension-0.4.0.crate"
  sha256 "fde7ef3e6cc439573683730d7bb5f598d804bfc169e0e9c8488e5e59ff762148"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "43bbb0659318bb2ebc904b95ddfca94d316afa5c48943e94f971577121e21456"
    sha256 cellar: :any, arm64_sequoia: "5c76772088e6ee172ac9d0d7a804a889111fc77b5f8bd65c4e77e51f07253845"
    sha256 cellar: :any, arm64_sonoma:  "561d1622c5e10b8e54aad3dd4dc4ebf98fd25d5bd9a527e4dab8f09ce3ff0da0"
    sha256 cellar: :any, sonoma:        "21feef5f4255d26a640f1cb9b98df975d8b4b745bd9a2a72a0a94faee521de42"
    sha256 cellar: :any, arm64_linux:   "0ff5a67aed26923e25204bcca3f58e9bccb12ca7478a118beb020a5c08b5a604"
    sha256 cellar: :any, x86_64_linux:  "a2ec37d52091c6b9d5c73ee2d2118bd3d138dab3f76f405bb8dcb2b783b9be52"
  end

  depends_on "rust" => :build
  depends_on "sqlite" # macOS sqlite can't load extensions

  def install
    cargo_args = std_cargo_args.reject { |arg| arg["--root"] || arg["--path"] }
    system "cargo", "build", "--lib", "--release", *cargo_args
    (lib/"sqlite").install shared_library("target/release/libhonker_ext")
  end

  def caveats
    <<~EOS
      The SQLite extension is installed in #{opt_lib}/sqlite.
      To load it in the SQLite CLI:
        .load #{opt_lib}/sqlite/libhonker_ext
    EOS
  end

  test do
    sql = <<~SQL
      .mode batch
      .load #{opt_lib}/sqlite/libhonker_ext
      SELECT honker_bootstrap();

      SELECT honker_enqueue('greetings', '{"name":"world"}',
                            NULL, NULL, 0, 3, NULL);

      SELECT honker_claim_batch('greetings', 'worker-1', 1, 300);
      -- Then ack the claimed job id from the JSON result above.
      SELECT honker_ack(1, 'worker-1');
    SQL
    expected_output = /1\n1\n\[{.*,"payload":"{\\"name\\":\\"world\\"}","queue":"greetings",.*}\]\n1/
    assert_match expected_output, pipe_output("#{formula_opt_bin("sqlite")}/sqlite3", sql)
  end
end
