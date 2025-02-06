class Greenmask < Formula
  desc "PostgreSQL dump and obfuscation tool"
  homepage "https://www.greenmask.io/"
  url "https://github.com/GreenmaskIO/greenmask/archive/refs/tags/v0.2.7.tar.gz"
  sha256 "da71261efb7f6866a28d227430c4b41e0a1a09f0eac6a597ae3800c0299765f3"
  license "Apache-2.0"
  head "https://github.com/GreenmaskIO/greenmask.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38f1af0eb904f1d48c52682eef8ec71ba753d767fe80f0250fd818558c5b3a63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38f1af0eb904f1d48c52682eef8ec71ba753d767fe80f0250fd818558c5b3a63"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "38f1af0eb904f1d48c52682eef8ec71ba753d767fe80f0250fd818558c5b3a63"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3ee79c68548c7dfcf456eb6f450a786774e9af5a58e68ff96ead080f9f4b7a3"
    sha256 cellar: :any_skip_relocation, ventura:       "c3ee79c68548c7dfcf456eb6f450a786774e9af5a58e68ff96ead080f9f4b7a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8fdb5295deed4a2e2cbf6688d2cdff9b01e414d66a522cfa651b7a7b2196337"
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
