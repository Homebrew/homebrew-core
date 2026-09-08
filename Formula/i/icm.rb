# typed: strict
# frozen_string_literal: true

class Icm < Formula
  desc "Permanent memory for AI agents — MCP server with hybrid search"
  homepage "https://github.com/rtk-ai/icm"
  url "https://github.com/rtk-ai/icm/archive/refs/tags/icm-v0.10.64.tar.gz"
  sha256 "4d17b2825d39775e8cfb84e1175edb7a7df1234dcbe3cc1ef1b3cfdbed606df7"
  license "Apache-2.0"
  head "https://github.com/rtk-ai/icm.git", branch: "main"

  depends_on "rust" => :build

  # cargo install fetches crate dependencies from crates.io during the
  # build step (icm-cli is not itself published to crates.io, so there is
  # no vendored/offline resource list — matches ripgrep's formula).
  allow_network_access! :build

  def install
    # embeddings-dynamic (issue #345): dlopens onnxruntime at runtime
    # instead of vendoring/downloading a prebuilt binary at build time —
    # the feature combination homebrew-core requires. Postgres/OpenSearch
    # backends are left out of the default build (native deps, additive
    # opt-in only relevant to server deployments, not the CLI/MCP tool
    # most `brew install` users want).
    system "cargo", "install", "--no-default-features", *std_cargo_args(
      path:     "crates/icm-cli",
      features: %w[embeddings-dynamic backend-sqlite tui http-api],
    )
  end

  test do
    assert_match "icm #{version}", shell_output("#{bin}/icm --version")

    db = testpath/"memories.db"
    system bin/"icm", "--db", db, "store", "-t", "test", "-c", "hello world", "--no-embeddings"
    assert_match "hello world",
                 shell_output("#{bin}/icm --db #{db} recall hello --no-embeddings")
  end
end
