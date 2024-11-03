class Greenmask < Formula
  desc "PostgreSQL dump and obfuscation tool"
  homepage "https://greenmask.io"
  url "https://github.com/GreenmaskIO/greenmask/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "d23cbf22c2470cb051091c274cb9d4d3a1a0332ef343be1c7dd15ac9fb1daf6d"
  license "Apache-2.0"
  head "https://github.com/GreenmaskIO/greenmask.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77747ab95dedda135b9cc87d91b863836a580be3848b770c03a9571ff53a1a3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77747ab95dedda135b9cc87d91b863836a580be3848b770c03a9571ff53a1a3b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "77747ab95dedda135b9cc87d91b863836a580be3848b770c03a9571ff53a1a3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b73cb7980abab946ead28712e22fa0abeb0202302c49c648003d05250cd4cac"
    sha256 cellar: :any_skip_relocation, ventura:       "6b73cb7980abab946ead28712e22fa0abeb0202302c49c648003d05250cd4cac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4708d40444135cb960d9c83cd95d48681d9cd660574b1842d7b59c1459c048de"
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

    output = shell_output("#{bin}/greenmask --config config.yml list-transformers")
    assert_match "Generate UUID", output
    assert_match "Generates a random word", output
  end
end
