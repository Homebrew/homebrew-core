class Greenmask < Formula
  desc "PostgreSQL dump and obfuscation tool"
  homepage "https://www.greenmask.io/"
  url "https://github.com/GreenmaskIO/greenmask/archive/refs/tags/v0.2.23.tar.gz"
  sha256 "f951d9d349497b669cb438141d5c4671d632d4bf29ea710f48cdc633289ebd6d"
  license "Apache-2.0"
  head "https://github.com/GreenmaskIO/greenmask.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc72c2cef0359080e79c3ce727852430df16f4cc23d00f95480e84c5a04f83ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc72c2cef0359080e79c3ce727852430df16f4cc23d00f95480e84c5a04f83ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc72c2cef0359080e79c3ce727852430df16f4cc23d00f95480e84c5a04f83ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ac4aebe53c9af3ca63ba274be9505f6fd37a4e74066eb85fee83e77c40a3369"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b54fd753ad573adbb01f813b4c7728b1eb77a251afce6fbeb88073f48c76be9"
    sha256 cellar: :any,                 x86_64_linux:  "5a20bb35ca0105564a1aee82a0e8eb86e0655493d1f95e72f92a65e1e53939ea"
  end

  depends_on "go" => :build

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
