class Greenmask < Formula
  desc "PostgreSQL dump and obfuscation tool"
  homepage "https://www.greenmask.io/"
  url "https://github.com/GreenmaskIO/greenmask/archive/refs/tags/v0.2.20.tar.gz"
  sha256 "5c25aeeb089c16ec09755d36a9369f47758f0c2bcff7e5e9d38329f4ccb47647"
  license "Apache-2.0"
  head "https://github.com/GreenmaskIO/greenmask.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ae0dc816ee8aebe56a585783575da6e79196b1842b96c2ba6b1836b44d817eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ae0dc816ee8aebe56a585783575da6e79196b1842b96c2ba6b1836b44d817eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ae0dc816ee8aebe56a585783575da6e79196b1842b96c2ba6b1836b44d817eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "08629b4fa5609c9bfa2269ee400f44e14c47ff2aea9850ccf55d0252396b47c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33e6550d014080edf15c0b91773554a1156292111ea0f0c1742b232bf137d8da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe9d28fb5a44cc12fe4dafdec092d58b039fb73d719c5b2b0883cb0bae14689e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/greenmaskio/greenmask/cmd/greenmask/cmd.Version=#{version}"
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
