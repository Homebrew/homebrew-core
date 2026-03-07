class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://github.com/dolthub/dolt/archive/refs/tags/v1.83.3.tar.gz"
  sha256 "ed08b6721ae75216ebb7cd9dcf6222fd57d96c7a3c70e5cdd329ab28ade3ce7e"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/dolthub/dolt.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ad3af25f5350814fc460f17c57a5fffaef80997a2e4b99ec2de4ebb2fa45af77"
    sha256 cellar: :any,                 arm64_sequoia: "64f625396f78877bd4408af34e242b42014c259cdbf81f76a62ee227a7689836"
    sha256 cellar: :any,                 arm64_sonoma:  "faa5b29dd5b18200c36ee817d6267f38e56938d7ea726d949fd8e16bb8640fa4"
    sha256 cellar: :any,                 sonoma:        "3c1d954140da9e033e8d44e0dddbaa3a6f1b1d12aaf68995ba2d7391cb83e505"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e40e8d87432b25bd22611dcdc2aaa4e89354ecaeb5731907b34b52240b34db89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea6d98274265a979f61563defbcdea67fefaecc3aa2a62bd53dc14064f26824e"
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
