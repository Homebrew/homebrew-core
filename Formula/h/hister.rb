class Hister < Formula
  desc "Self-hosted search engine for your browsing history"
  homepage "https://hister.org/"
  url "https://github.com/asciimoo/hister/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "59cbe6d03a7e7783e4922ea03fbbbe812701c50eb5f49f6a3c42d9480ebdd2ba"
  license "AGPL-3.0-or-later"
  head "https://github.com/asciimoo/hister.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3b433c5071f67bdf2a8eea17526b0c86a4f0349d9a1a58af7283b9d69347740f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8d17490b2150546a7a32cf9bec941a346216022ef9d61138e49bfbd96a1c60f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "04b6dc9b97628ade2030f47ebead521b2c62f8a22a1a033c30fe2ac7e1a10064"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "eec45ff1434d470e6686b6c3db4e16293ae53ac5625d009fb761804297e0d01c"
    sha256 cellar: :any,                 arm64_linux:       "9da9f989ca9b5092fad77de291c1d35659eb5c4dcd253a192110176877635816"
    sha256 cellar: :any,                 x86_64_linux:      "88d0cdea162858c08771c7400bca74fa6ec5cb4847c6a65cfb53aff2fe915e6b"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
    system "npm", "ci", "--workspaces", "--include=optional"
  end

  def install
    system "npm", "--offline", "run", "build", "--workspace=@hister/app"
    (buildpath/"server/static/app").install Dir["webui/app/build/*"]

    ENV["CGO_ENABLED"] = "1" if OS.linux?
    ENV["GOPROXY"] = "off"
    system "go", "build", *std_go_args
    generate_completions_from_executable(bin/"hister", "completion")
  end

  service do
    run [opt_bin/"hister", "listen"]
    keep_alive true
    environment_variables HISTER_DATA_DIR: var/"hister"
    log_path var/"log/hister.log"
    error_log_path var/"log/hister.log"
    working_dir var/"hister"
  end

  test do
    require "yaml"

    ENV["HISTER_DATA_DIR"] = testpath/"data"
    assert_match version.to_s, shell_output("#{bin}/hister --version")

    config = testpath/"hister.yml"
    system bin/"hister", "create-config", config
    assert_match "app:", config.read

    documents = testpath/"documents"
    documents.mkpath
    (documents/"note.md").write "Homebrew test document"
    (documents/"ignored.txt").write "Excluded by the file type filter"

    config_data = YAML.safe_load(config.read)
    config_data["indexer"]["directories"] = [{ "path" => documents.to_s, "filetypes" => ["md"] }]
    config.atomic_write config_data.to_yaml

    assert_equal "note.md\n", shell_output("#{bin}/hister --config #{config} list-files --relative")
  end
end
