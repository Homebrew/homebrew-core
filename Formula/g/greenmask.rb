class Greenmask < Formula
  desc "PostgreSQL dump and obfuscation tool"
  homepage "https://greenmask.io"
  url "https://github.com/GreenmaskIO/greenmask/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "fc3e9d556f21447dff6bec58d4070c319f0725eef99dd8258d34ecfe41f4192e"
  license "Apache-2.0"
  head "https://github.com/GreenmaskIO/greenmask.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a5c68520bbe6792e51cdf4154629fb9bf57c0b7bf829d221109d5663e4d2b63"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c289fc4b013a8c30d681cf05a07d4be638b115301c15e07b963a69f92cec73a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d07e8ccf7011fa067353cbd9dbcde4d631503da9b47c52ff778f6b4a246eb55d"
    sha256 cellar: :any_skip_relocation, sonoma:         "03090ede39fb4c79d1525c029aebe9b07d5b9a8fc725cfe0194494fb0bb2b867"
    sha256 cellar: :any_skip_relocation, ventura:        "6bf6849e4d24947c7552f2b4079406aefb9f08415e98b62742008298415f38e0"
    sha256 cellar: :any_skip_relocation, monterey:       "c50f9e983c219d940cdc3a8bb140e7dbd92717ffabbe3aca096cd6e90a9f2a18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f075a46ebc0d6b9af433e2a06accdd3747205d3e53fba6728bdcac0b957c0f5"
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

    (testpath/"config.yml").write <<~EOS
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
    EOS
    output = shell_output(bin/"greenmask --config config.yml list-transformers")
    assert_match "Generate random uuid", output
  end
end
