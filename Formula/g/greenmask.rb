class Greenmask < Formula
  desc "PostgreSQL dump and obfuscation tool"
  homepage "https://www.greenmask.io/"
  url "https://github.com/GreenmaskIO/greenmask/archive/refs/tags/v0.2.15.tar.gz"
  sha256 "d9cc46c66caf3610abe35feda46cb3e341faaf8b7b3503dfc964357da9def21c"
  license "Apache-2.0"
  head "https://github.com/GreenmaskIO/greenmask.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6566ad58caea4006f873235d0f016a243c93c1ad99a4b17d5ab5051cdd264482"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6566ad58caea4006f873235d0f016a243c93c1ad99a4b17d5ab5051cdd264482"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6566ad58caea4006f873235d0f016a243c93c1ad99a4b17d5ab5051cdd264482"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ca0a8491c68f12ffdbb48ea4bd34a38d9c0ca247969aebde5405db32e27884e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dcb3e75cefbab8ba63885b06bc585e45dc115751ffb0e4e73523be0387ae36c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82b797ee59e812456347e03bc649c0e5a1460d80e435006f00f90c787e8b3ecc"
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
