class Greenmask < Formula
  desc "PostgreSQL dump and obfuscation tool"
  homepage "https://greenmask.io"
  url "https://github.com/GreenmaskIO/greenmask/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "a6dc6978620b6b19796ee8ad37f7ba8123c2b9ec4450e7e1ce69dbaea6b0e926"
  license "Apache-2.0"
  head "https://github.com/GreenmaskIO/greenmask.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b6f8cfb46733206a15c94dc80de40dc7a98315d01cd85c88cae046cef4d4d1d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98d29170437db4f4d01e9e6435c2452fc24d0743bbb4e5fb489088fc77a59f9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29fe27dd2be7d413ec984d9df1f81f2d83cc25669c9064a649f908f80c169346"
    sha256 cellar: :any_skip_relocation, sonoma:         "68367ff529284a6a64a50d817f5c05f03cd57ddc11189f95ddab4fd265398c6e"
    sha256 cellar: :any_skip_relocation, ventura:        "6f0c6197d59e6f120e29502baad85a465f624a3662f8440fc43ee2e66976b92e"
    sha256 cellar: :any_skip_relocation, monterey:       "7e519a47aa91292607967f6cca7b515f01bba2abeb712f7025d09a14440cd392"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "146c5110ddf5f4075d8ebc6decc88e04b22d215cd259a2e75db1e2b2e43fb5d6"
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
