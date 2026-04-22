class Greenmask < Formula
  desc "PostgreSQL dump and obfuscation tool"
  homepage "https://www.greenmask.io/"
  url "https://github.com/GreenmaskIO/greenmask/archive/refs/tags/v0.2.19.tar.gz"
  sha256 "6b8b3034edc46fee210313b249938c7ba2ac28829c2a00e692d65f62c8c13cec"
  license "Apache-2.0"
  head "https://github.com/GreenmaskIO/greenmask.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8c14eec3dd0861607a9fa795d4fe6fb1cdcf5666ac22bb57d11f8768be5ef3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8c14eec3dd0861607a9fa795d4fe6fb1cdcf5666ac22bb57d11f8768be5ef3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8c14eec3dd0861607a9fa795d4fe6fb1cdcf5666ac22bb57d11f8768be5ef3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "509b845401c0acab7989d2f5c62af41c0d449e527441b538ccaa09fa4e08b44f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ae6629186700f14722df6562b516c1f8d5db07ecb54e502cbf5d5817ecfe0a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e9ba0fe7b12fc6eaa83954e72c7de22280969a283f548158574bf9f9261331e"
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
