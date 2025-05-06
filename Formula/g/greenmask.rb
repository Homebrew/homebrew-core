class Greenmask < Formula
  desc "PostgreSQL dump and obfuscation tool"
  homepage "https://www.greenmask.io/"
  url "https://github.com/GreenmaskIO/greenmask/archive/refs/tags/v0.2.11.tar.gz"
  sha256 "ef519a961a533ae88f577bab057d4ecfc8b7e2aaaf94f93d5ebeba07c95bfcc7"
  license "Apache-2.0"
  head "https://github.com/GreenmaskIO/greenmask.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccd2b371a74884ca3fa4323f1e48655ff3e168a328797b6ffe9ae57657820670"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccd2b371a74884ca3fa4323f1e48655ff3e168a328797b6ffe9ae57657820670"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ccd2b371a74884ca3fa4323f1e48655ff3e168a328797b6ffe9ae57657820670"
    sha256 cellar: :any_skip_relocation, sonoma:        "8fd591ad4f84223c2ed3d68b3b77937e399d14804d47df9d6a6455fff04f8ad2"
    sha256 cellar: :any_skip_relocation, ventura:       "8fd591ad4f84223c2ed3d68b3b77937e399d14804d47df9d6a6455fff04f8ad2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adcb92bda3e4a6a0692f145d1ac35cc785546148de20c2ed85cf201ee64a1d4b"
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
