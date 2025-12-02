class Greenmask < Formula
  desc "PostgreSQL dump and obfuscation tool"
  homepage "https://www.greenmask.io/"
  url "https://github.com/GreenmaskIO/greenmask/archive/refs/tags/v0.2.14.tar.gz"
  sha256 "093e677914f3191de33bca479debd5305fff68420055873b3e331f829748f2c5"
  license "Apache-2.0"
  head "https://github.com/GreenmaskIO/greenmask.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40f7addd4b7753351668fc425edc44d851de3b552625d8384938b3f699c7206a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40f7addd4b7753351668fc425edc44d851de3b552625d8384938b3f699c7206a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40f7addd4b7753351668fc425edc44d851de3b552625d8384938b3f699c7206a"
    sha256 cellar: :any_skip_relocation, sonoma:        "eab90a00c7deaac2172b89e011d7e9fe36e0661b8f65d6f16066217ae27edb6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c1e3fe7445896196e5d14731a4fedafad292b0cbd3bbff3889dc417766e4210"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf3a3d87ffa8bc41a5720ec6a7e8e82cbdaf5e7f0771b9b4ec9be94ae8ce3fdc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/greenmaskio/greenmask/cmd/greenmask/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, tags: "viper_bind_struct"), "./cmd/greenmask"

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
