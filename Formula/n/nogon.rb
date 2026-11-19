class Nogon < Formula
  desc "Self-hosted search engine for your browsing history"
  homepage "https://nogon.eu/"
  url "https://github.com/asciimoo/nogon/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "e78fe5fb2d8c612f06104605aa234c8840eab0f14146829757706b59258c0154"
  license "AGPL-3.0-or-later"
  head "https://github.com/asciimoo/nogon.git", branch: "master"

  depends_on "go" => :build
  depends_on "node" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
    system "npm", "ci", "--workspaces", "--include=optional"
  end

  def install
    system "npm", "--offline", "run", "build", "--workspace=@nogon/app"
    (buildpath/"server/static/app").install Dir["webui/app/build/*"]

    ENV["CGO_ENABLED"] = "1" if OS.linux?
    ENV["GOPROXY"] = "off"
    system "go", "build", *std_go_args
    generate_completions_from_executable(bin/"nogon", "completion")
  end

  def caveats
    <<~CAVEATS
      The hister command has been renamed to nogon. Update scripts that call hister.
      If you ran Hister as a Homebrew service, run `brew services restart nogon` after upgrading.
    CAVEATS
  end

  service do
    # Keep the existing service identity and data directory on upgrade.
    name macos: "sh.brew.hister", linux: "sh.brew.hister"
    run [opt_bin/"nogon", "listen"]
    keep_alive true
    environment_variables HISTER_DATA_DIR: var/"hister"
    log_path var/"log/hister.log"
    error_log_path var/"log/hister.log"
    working_dir var/"hister"
  end

  test do
    require "yaml"

    ENV["HISTER_DATA_DIR"] = testpath/"data"
    assert_match version.to_s, shell_output("#{bin}/nogon --version")

    config = testpath/"nogon.yml"
    system bin/"nogon", "config", "create", "--full", config
    assert_match "app:", config.read

    documents = testpath/"documents"
    documents.mkpath
    (documents/"note.md").write "Homebrew test document"
    (documents/"ignored.txt").write "Excluded by the file type filter"

    config_data = YAML.safe_load(config.read)
    config_data["indexer"]["directories"] = [{ "path" => documents.to_s, "filetypes" => ["md"] }]
    config.atomic_write config_data.to_yaml

    assert_equal "note.md\n", shell_output("#{bin}/nogon --config #{config} list-files --relative")
  end
end
