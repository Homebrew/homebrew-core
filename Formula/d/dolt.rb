class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.82.6.tar.gz"
  sha256 "f847b5f0e74f53ca828b690550546e84727868cd37c24fd8b66ab600c1fb5c87"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "566e39a68fec4c156696396ce0c2b97ab001a201a132c4b0977d9fa11f311688"
    sha256 cellar: :any,                 arm64_sequoia: "a56832640434a44314a887a93c31d6ab26ddd55821a6d34dfc5c2a83196edfff"
    sha256 cellar: :any,                 arm64_sonoma:  "7e9b259d21fc0f6a60833cd7a9bc1dd888aae33258c23aae268754db43fae4c6"
    sha256 cellar: :any,                 sonoma:        "db4d57ac7af15a91c2a3c03c91be7c9af6a99a4fbf32d1d51dc9fbae8de1ef92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d7746662120a3cfc454b14c34fea8b3d03d82b6290bc1d24786c0e69838ad11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "018fc1395099ed406c4fe8c9a279dc2627777efaf1de90a68253d1b900e6ee1a"
  end

  depends_on "go" => :build
  depends_on "icu4c@78"

  def install
    ENV["CGO_ENABLED"] = "1"

    system "go", "build", "-C", "go", *std_go_args(ldflags: "-s -w"), "./cmd/dolt"

    (var/"log").mkpath
    (var/"dolt").mkpath
    (etc/"dolt").mkpath
    (etc/"dolt/config.yaml").write(config_yaml) unless (etc/"dolt/config.yaml").exist?
  end

  def config_yaml
    <<~YAML
      # Dolt SQL Server configuration
      # Full documentation: https://docs.dolthub.com/sql-reference/server/configuration
      listener:
        host: localhost
        port: 3306
    YAML
  end

  service do
    run [opt_bin/"dolt", "sql-server", "--config", etc/"dolt/config.yaml"]
    keep_alive true
    log_path var/"log/dolt.log"
    error_log_path var/"log/dolt.error.log"
    working_dir var/"dolt"
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end
