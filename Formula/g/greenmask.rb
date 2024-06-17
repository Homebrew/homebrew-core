class Greenmask < Formula
  desc "PostgreSQL dump and obfuscation tool"
  homepage "https://greenmask.io"
  url "https://github.com/GreenmaskIO/greenmask/archive/refs/tags/v0.1.14.tar.gz"
  sha256 "b5d7323d9dde7e4fcd288c461f6454b6e0e4e2b09eb62619cb967bf14971c990"
  license "Apache-2.0"
  head "https://github.com/GreenmaskIO/greenmask.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25bcd6ff301712eff33ede67836cca16265b96b3b3047d7b4a1580fa0b845e5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da9353cc79191b3dfa604deb72b9e4a5b4544f43ceba0ba0657f290ecf31b80b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0b4321544ba5d050aff079a2112b758f877bc25084253fbd233fa8ef6943f4f"
    sha256 cellar: :any_skip_relocation, sonoma:         "91c54d885a31b0bb023055a4d4b4adc2952d4f6be169a46daf43bf8b25fa859f"
    sha256 cellar: :any_skip_relocation, ventura:        "4cc11e565ab57dbab9ccd14c182630801edaceb76ed5978f516600f9cdc67e52"
    sha256 cellar: :any_skip_relocation, monterey:       "490accb892eaf2e620adc6a24255e6f6625d33e93485512eebb9fddd01f3b84e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85a81586265d8353a4259e5d53a74cbd7a9b458f063fa08da3fc53cb64eb1b80"
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
