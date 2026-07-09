class Greenmask < Formula
  desc "PostgreSQL dump and obfuscation tool"
  homepage "https://www.greenmask.io/"
  url "https://github.com/GreenmaskIO/greenmask/archive/refs/tags/v0.2.22.tar.gz"
  sha256 "56eab71fc727ab1c7e14e93cf3715038b23afc2454a939b1c24151091caeec1c"
  license "Apache-2.0"
  head "https://github.com/GreenmaskIO/greenmask.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd584a6068c6ce35cfd9c05dc9a815fe076c1ec7a8c7e6faed4c9521a388ab68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd584a6068c6ce35cfd9c05dc9a815fe076c1ec7a8c7e6faed4c9521a388ab68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd584a6068c6ce35cfd9c05dc9a815fe076c1ec7a8c7e6faed4c9521a388ab68"
    sha256 cellar: :any_skip_relocation, sonoma:        "177a38a7599ce285340309917e80e9d3a45bc6b3ca75ef68a187b08a62cf88ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d31705a5af21324f4cad2e4b99754e34c292013ac425ab7cd3784d1364bca8e2"
    sha256 cellar: :any,                 x86_64_linux:  "db0bf0e760abf09489783fa55cbdfdbe5456501ef5320914ea5f9be50d946c5d"
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
