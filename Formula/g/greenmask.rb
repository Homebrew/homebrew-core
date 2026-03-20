class Greenmask < Formula
  desc "PostgreSQL dump and obfuscation tool"
  homepage "https://www.greenmask.io/"
  url "https://github.com/GreenmaskIO/greenmask/archive/refs/tags/v0.2.17.tar.gz"
  sha256 "dfb8cfd950c77832125014217587d9735a2cac0f4a68a8a5f5890f4dc4330b29"
  license "Apache-2.0"
  head "https://github.com/GreenmaskIO/greenmask.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b24a8d3a68fbb30c9d7abe222ec0e04e5d75ac02f04d4a1e193e955736b0240b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b24a8d3a68fbb30c9d7abe222ec0e04e5d75ac02f04d4a1e193e955736b0240b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b24a8d3a68fbb30c9d7abe222ec0e04e5d75ac02f04d4a1e193e955736b0240b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7ad91a3029717c4d9c388249531fca3261e7cf64e83ca34d303497b5125dacea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af22a74f1c6896a6479d22fef6d8f6cfdd148510c6ed3e52ca372b280cbf3d11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e847e621a19c4a1831411e12cc41755d3ec6b69be0a220144d2d422159fbcd3a"
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
