class Greenmask < Formula
  desc "PostgreSQL dump and obfuscation tool"
  homepage "https://www.greenmask.io/"
  url "https://github.com/GreenmaskIO/greenmask/archive/refs/tags/v0.2.18.tar.gz"
  sha256 "631e34d0339b7dd413038590bca982b98bcb8f6512749af6baeb7284b48ce068"
  license "Apache-2.0"
  head "https://github.com/GreenmaskIO/greenmask.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "265c2450b88a010a1aabef43470525409ff3a53852efbb12a22ee25ec0398e72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "265c2450b88a010a1aabef43470525409ff3a53852efbb12a22ee25ec0398e72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "265c2450b88a010a1aabef43470525409ff3a53852efbb12a22ee25ec0398e72"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ff8fd84e94aca95b38204e22d1eb8dfe794802662a66aa401fa292a63f6e7e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07ccc213d53e3fb9ac111fe877ca670b93af0b7df9c991971c288e08290af55f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1792fe2c18802dc9ee067d4cbc3460b5909662859c1aeb26e645efc1e4fdef9b"
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
