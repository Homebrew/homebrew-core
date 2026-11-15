class Hister < Formula
  desc "Self-hosted search engine for your browsing history"
  homepage "https://hister.org/"
  url "https://github.com/asciimoo/hister/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "b47d349d5c14b4b0c142ed7dd9583d276c20658677a483fcf7331beb9735bf0a"
  license "AGPL-3.0-or-later"
  head "https://github.com/asciimoo/hister.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fc1bdf302a57c4196af776d653a4b660702f0f0ef08f993b861df33c8aa6321b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "990dbbff43e4ef24bf054604107a4efdb1ed766f28664c37439c589527ec491f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "23e9708c7c039ac7ce0b571c51a18757c149f667c4672625c877c465bdc51a6d"
    sha256 cellar: :any,                 arm64_linux:       "cbf070c038bf7b0848f113b990e00fe735503fff9ab8c0f86f13cebdbf14d10e"
    sha256 cellar: :any,                 x86_64_linux:      "76758589fbfbfa6af3b07dba818718e5ebb934bba78eda801d93496069672f15"
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
