class Honker < Formula
  desc "SQLite message queue extension"
  homepage "https://honker.dev"
  url "https://static.crates.io/crates/honker-extension/honker-extension-0.5.0.crate"
  sha256 "e63f3f389f225cd250a2846becbadf15c91dc25285cb1bd43901187c8f1e3774"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "562bf73b8888259b4e1613e0567652fdf2ee502e4673212b49445de55d8f5908"
    sha256 cellar: :any, arm64_sequoia: "8719b00e1fd3e2ab3cfba52260c1174e2e325ff6273032aeb7b03b47a8619d8c"
    sha256 cellar: :any, arm64_sonoma:  "b35f326a013965b32b0cabdb0087fea3c7f6b8a8df0fd6f9d3a2b29b4d7e7207"
    sha256 cellar: :any, sonoma:        "9cf40865171a765a1ace762cba0361eede5c0d877d0afe9e16859115e0e9eadd"
    sha256 cellar: :any, arm64_linux:   "bf7dae7e1f3cd9a78a50b0481c888ea19aeb8fd9b7a00c68b376be5c3d93b1a6"
    sha256 cellar: :any, x86_64_linux:  "c3dca99100c82b6d69de44b8cf1490ecde6c4e9ac6d5d8454696f17d522e3342"
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
