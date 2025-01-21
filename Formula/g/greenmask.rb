class Greenmask < Formula
  desc "PostgreSQL dump and obfuscation tool"
  homepage "https://greenmask.io"
  url "https://github.com/GreenmaskIO/greenmask/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "bd641d022a29e659b5c15e983031aceda5e12a4379312bc8dc82a4e32d71870b"
  license "Apache-2.0"
  head "https://github.com/GreenmaskIO/greenmask.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd336499d2ead297c85d7d4ed7f56bccf9aa3eb553667bcb7c1fb266cac1a95d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd336499d2ead297c85d7d4ed7f56bccf9aa3eb553667bcb7c1fb266cac1a95d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bd336499d2ead297c85d7d4ed7f56bccf9aa3eb553667bcb7c1fb266cac1a95d"
    sha256 cellar: :any_skip_relocation, sonoma:        "289ab6010b5fbeb8401bee9c428ab0eec9c02c91c761ccffe8300610f9076596"
    sha256 cellar: :any_skip_relocation, ventura:       "289ab6010b5fbeb8401bee9c428ab0eec9c02c91c761ccffe8300610f9076596"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be7d91b41522111a21bb23e88549b20a73c4e3a00eab3c9ae939b9f65972eaf8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/greenmaskio/greenmask/cmd/greenmask/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/greenmask"

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
