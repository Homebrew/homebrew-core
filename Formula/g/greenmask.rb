class Greenmask < Formula
  desc "PostgreSQL dump and obfuscation tool"
  homepage "https://www.greenmask.io/"
  url "https://github.com/GreenmaskIO/greenmask/archive/refs/tags/v0.2.21.tar.gz"
  sha256 "076538538f16a3e40586b0ac25e78e8b4de54d91a5dee4e757a38d8c1a0da7b1"
  license "Apache-2.0"
  head "https://github.com/GreenmaskIO/greenmask.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f5183747155a6dfb828abae3934fd8ef9dcc6bcc4d75f902d63ce956430c174"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f5183747155a6dfb828abae3934fd8ef9dcc6bcc4d75f902d63ce956430c174"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f5183747155a6dfb828abae3934fd8ef9dcc6bcc4d75f902d63ce956430c174"
    sha256 cellar: :any_skip_relocation, sonoma:        "646212290560c2c3a5c6c0f983e1c829c8b905cb6fd4d144e251b39cc024562a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6889156b0b408f1f922f442a7d8daddd4db49fc8913b5df47905056d0d6b6b8"
    sha256 cellar: :any,                 x86_64_linux:  "0150333b7f1e926f86bd69dbb0e7bdda0b6ec0ca17bd1e5a56a593e05eace45f"
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
