class Greenmask < Formula
  desc "PostgreSQL dump and obfuscation tool"
  homepage "https://www.greenmask.io/"
  url "https://github.com/GreenmaskIO/greenmask/archive/refs/tags/v0.2.12.tar.gz"
  sha256 "6fb41ac36ab1c8b528eb38b167164d92d785b38f33ca814b9e5fdc91e978a72e"
  license "Apache-2.0"
  head "https://github.com/GreenmaskIO/greenmask.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f68b41516ee7bc1b59efb5c8925424f496fe6abf080b44a71845714277b0f44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f68b41516ee7bc1b59efb5c8925424f496fe6abf080b44a71845714277b0f44"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f68b41516ee7bc1b59efb5c8925424f496fe6abf080b44a71845714277b0f44"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed71bea3d91f15a558403386c6cb3e3b7567935f9e18ca51f191cdc23c266dc3"
    sha256 cellar: :any_skip_relocation, ventura:       "ed71bea3d91f15a558403386c6cb3e3b7567935f9e18ca51f191cdc23c266dc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97ca47fb8ee0ca2804996efb7b5541d7ab1a102bf2e22f0c8383b1ef99f1d935"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/greenmaskio/greenmask/cmd/greenmask/cmd.Version=#{version}
    ]
    system "go", "build", "-tags=viper_bind_struct", *std_go_args(ldflags:), "./cmd/greenmask"

    generate_completions_from_executable(bin/"greenmask", "completion")
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
