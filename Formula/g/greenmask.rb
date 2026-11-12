class Greenmask < Formula
  desc "PostgreSQL dump and obfuscation tool"
  homepage "https://www.greenmask.io/"
  url "https://github.com/GreenmaskIO/greenmask/archive/refs/tags/v0.2.27.tar.gz"
  sha256 "d4cbb8dfe2c399d5c37764d7ba4320032cfae25569b658bd8f1f3f489bf92675"
  license "Apache-2.0"
  head "https://github.com/GreenmaskIO/greenmask.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "93df83f8b1a139e612be941eb789350af8a216e248fde81b70bdcfd0598369f9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "93df83f8b1a139e612be941eb789350af8a216e248fde81b70bdcfd0598369f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "93df83f8b1a139e612be941eb789350af8a216e248fde81b70bdcfd0598369f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "49933f959d63b726767faa7eefdc60fc5b2341c48f8d229ee874d33dc6794872"
    sha256 cellar: :any,                 x86_64_linux:      "b1e45992bda13e554f2b9a4e63b402f5d8b9c72156c306b7088e42623836c69c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/greenmaskio/greenmask/cmd/greenmask/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, tags: "viper_bind_struct"), "./cmd/greenmask"

    generate_completions_from_executable(bin/"greenmask", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/greenmask -v")

    (testpath/"config.yml").write <<~YAML
      common:
        pg_bin_path: "/usr/lib/postgresql/16/bin"
        tmp_dir: "/tmp"

      storage:
        s3:
          endpoint: "http://playground-storage:9000"
          bucket: "adventureworks"
          region: "us-east-1"
          access_key_id: "Q3AM3UQ867SPQQA43P2F"
          secret_access_key: "zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG"

      validate:
      #  resolved_warnings:
      #    - "aa808fb574a1359c6606e464833feceb"

      dump:
        pg_dump_options: # pg_dump option that will be provided
          dbname: "host=playground-db user=postgres password=example dbname=original"
          jobs: 10

        transformation: # List of tables to transform
          - schema: "humanresources" # Table schema
            name: "employee"  # Table name
            transformers: # List of transformers to apply
              - name: "NoiseDate" # name of transformers
                params: # Transformer parameters
                  ratio: "10 year 9 mon 1 day"
                  column: "birthdate" # Column parameter - this transformer affects scheduled_departure column

      restore:
        pg_restore_options: # pg_restore option (you can use the same options as pg_restore has)
          jobs: 10
          dbname: "host=playground-db user=postgres password=example dbname=transformed"
    YAML

    output = shell_output("#{bin}/greenmask --config config.yml list-transformers")
    assert_match "Generate UUID", output
    assert_match "Generates a random word", output
  end
end
