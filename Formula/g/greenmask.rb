class Greenmask < Formula
  desc "PostgreSQL dump and obfuscation tool"
  homepage "https://www.greenmask.io/"
  url "https://github.com/GreenmaskIO/greenmask/archive/refs/tags/v0.2.16.tar.gz"
  sha256 "552ac3d56bea6c4f6a3a9008afcdcc0ad739170a8313ae1789be22703947ce81"
  license "Apache-2.0"
  head "https://github.com/GreenmaskIO/greenmask.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9de54eb221e7365acebf3c36e2418f8a77b2a271313edddeb8659fa9ade39b7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9de54eb221e7365acebf3c36e2418f8a77b2a271313edddeb8659fa9ade39b7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9de54eb221e7365acebf3c36e2418f8a77b2a271313edddeb8659fa9ade39b7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ae06d47899e6715671b666aac8d2c492785051d7eaf8474832e2b969c287369"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f886926b62ddace9bc9febfa81578ee27ed1d05eb5402ee181d613673c18a1aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31ca8501447b8187e578105f3ab608217b46dc5acadb416295be64eecbea56e9"
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
